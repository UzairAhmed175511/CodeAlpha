import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/fitness_view_model.dart';
import '../models/fitness_entry.dart';

class CalorieBurnScreen extends StatefulWidget {
  const CalorieBurnScreen({super.key});

  @override
  State<CalorieBurnScreen> createState() => _CalorieBurnScreenState();
}

class _CalorieBurnScreenState extends State<CalorieBurnScreen> {
  final _activities = {
    'Walking (slow)': 3.5,
    'Walking (fast)': 5.0,
    'Running': 9.8,
    'Cycling': 7.5,
    'Swimming': 8.0,
    'Yoga': 3.0,
    'Strength Training': 6.0,
  };

  String? _selectedActivity;
  double _weight = 70;
  double _duration = 30;
  double? _caloriesBurned;

  double calculateCalories() {
    if (_selectedActivity == null) return 0.0;
    final met = _activities[_selectedActivity]!;
    return (met * 3.5 * _weight * _duration) / 200;
  }

  void saveEntry(BuildContext context) {
    if (_caloriesBurned == null || _caloriesBurned == 0) return;

    final today =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

    final entry = FitnessEntry(
      date: today,
      steps: 0,
      calories: _caloriesBurned!,
      workoutMinutes: _duration,
      activity: _selectedActivity ?? "Unknown",
    );

    Provider.of<FitnessViewModel>(context, listen: false).addEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Calories saved to Fitness Summary ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calorie Burn Estimator 🔥")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Choose your activity:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedActivity,
              hint: const Text("Select activity"),
              isExpanded: true,
              items: _activities.keys
                  .map(
                    (activity) => DropdownMenuItem(
                      value: activity,
                      child: Text(activity),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedActivity = value;
                });
              },
            ),
            const SizedBox(height: 25),
            Text(
              "Your weight: ${_weight.toStringAsFixed(0)} kg",
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: _weight,
              min: 40,
              max: 120,
              divisions: 80,
              label: "${_weight.toStringAsFixed(0)} kg",
              onChanged: (v) => setState(() => _weight = v),
            ),
            const SizedBox(height: 20),
            Text(
              "Duration: ${_duration.toStringAsFixed(0)} minutes",
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: _duration,
              min: 10,
              max: 180,
              divisions: 17,
              label: "${_duration.toStringAsFixed(0)} min",
              onChanged: (v) => setState(() => _duration = v),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                setState(() {
                  _caloriesBurned = calculateCalories();
                });
              },
              icon: const Icon(Icons.calculate),
              label: const Text("Calculate Calories"),
            ),
            const SizedBox(height: 25),
            if (_caloriesBurned != null)
              Card(
                color: Colors.deepPurple.shade50,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Estimated Calories Burned",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${_caloriesBurned!.toStringAsFixed(1)} kcal",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () => saveEntry(context),
                        icon: const Icon(Icons.save),
                        label: const Text("Save to Fitness Summary"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:fitness_tracker_app/view_models/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fitness_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final stepsController = TextEditingController();
  final workoutController = TextEditingController();
  final caloriesController = TextEditingController();

  // Dropdown for activity
  final List<String> _activities = [
    'Running',
    'Walking',
    'Cycling',
    'Swimming',
    'Yoga',
    'Gym Workout',
  ];

  String? _selectedActivity;

  // 🔥 Activity calorie rates (kcal/min)
  final Map<String, double> _activityRates = {
    'Running': 10.0,
    'Walking': 5.0,
    'Cycling': 8.0,
    'Swimming': 9.0,
    'Yoga': 4.0,
    'Gym Workout': 7.0,
  };

  void _updateCalories() {
    if (_selectedActivity != null && workoutController.text.isNotEmpty) {
      final minutes = double.tryParse(workoutController.text) ?? 0;
      final rate = _activityRates[_selectedActivity] ?? 6.0;
      final calculated = rate * minutes;

      setState(() {
        caloriesController.text = calculated.toStringAsFixed(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FitnessViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Fitness Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Select activity
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Activity",
                border: OutlineInputBorder(),
              ),
              value: _selectedActivity,
              items: _activities.map((activity) {
                return DropdownMenuItem(value: activity, child: Text(activity));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedActivity = value;
                });
                _updateCalories();
              },
            ),
            const SizedBox(height: 20),

            // Steps (optional)
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Steps (if applicable)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Workout minutes
            TextField(
              controller: workoutController,
              keyboardType: TextInputType.number,
              onChanged: (_) => _updateCalories(),
              decoration: const InputDecoration(
                labelText: 'Workout Minutes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Auto-calculated calories
            TextField(
              controller: caloriesController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Calories Burned (Auto)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            ElevatedButton.icon(
              onPressed: () async {
                if (_selectedActivity == null ||
                    workoutController.text.isEmpty ||
                    caloriesController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                    ),
                  );
                  return;
                }

                final entry = FitnessEntry(
                  date: DateTime.now().toString().split(' ')[0],
                  steps: int.tryParse(stepsController.text) ?? 0,
                  calories: double.tryParse(caloriesController.text) ?? 0,
                  workoutMinutes: double.tryParse(workoutController.text) ?? 0,
                  activity: _selectedActivity ?? 'Unknown',
                );

                await viewModel.addEntry(entry);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nutrition_entry.dart';
import '../view_models/nutrition_view_model.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NutritionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Nutrition Tracker 🍎")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Total Calories: ${viewModel.totalCalories} kcal",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.entries.length,
                itemBuilder: (context, index) {
                  final entry = viewModel.entries[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.restaurant,
                        color: Colors.orange,
                      ),
                      title: Text(entry.meal),
                      subtitle: Text(
                        "Calories: ${entry.calories} • Date: ${entry.date}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: const Text("Add Meal"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final mealController = TextEditingController();
    final calorieController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Meal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: mealController,
              decoration: const InputDecoration(labelText: "Meal name"),
            ),
            TextField(
              controller: calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Calories"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final meal = mealController.text.trim();
              final calories = int.tryParse(calorieController.text) ?? 0;
              if (meal.isNotEmpty && calories > 0) {
                final today =
                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                final entry = NutritionEntry(
                  date: today,
                  meal: meal,
                  calories: calories,
                );
                Provider.of<NutritionViewModel>(
                  context,
                  listen: false,
                ).addEntry(entry);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

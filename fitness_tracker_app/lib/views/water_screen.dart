import 'package:fitness_tracker_app/models/water_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/water_view_model.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WaterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Water Intake Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Today's Hydration 💧",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              "${viewModel.totalGlasses} Glasses (${viewModel.totalLiters.toStringAsFixed(2)} L)",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                final entry = WaterEntry(
                  date: DateTime.now().toString().split(' ').first,
                  glasses: 1,
                );
                viewModel.addEntry(entry);
              },
              icon: const Icon(Icons.local_drink, color: Colors.white),
              label: const Text("Add 1 Glass"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.entries.length,
                itemBuilder: (context, index) {
                  final e = viewModel.entries[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.water_drop,
                        color: Colors.blueAccent,
                      ),
                      title: Text("${e.glasses} Glasses"),
                      subtitle: Text("Date: ${e.date}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () => viewModel.clearEntries(),
        label: const Text("Clear All"),
        icon: const Icon(Icons.delete),
      ),
    );
  }
}

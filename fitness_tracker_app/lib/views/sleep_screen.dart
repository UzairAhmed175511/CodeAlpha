import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/sleep_view_model.dart';
import '../models/sleep_entry.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SleepViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Average Sleep: ${viewModel.averageSleep.toStringAsFixed(1)} hrs 😴",
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
                        Icons.bedtime,
                        color: Colors.deepPurple,
                      ),
                      title: Text("${entry.hours} hrs"),
                      subtitle: Text("Date: ${entry.date}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final today =
              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

          // Prompt user for hours slept
          final controller = TextEditingController();
          final hours = await showDialog<double>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Sleep Record"),
              content: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: "Hours slept"),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, double.tryParse(controller.text)),
                  child: const Text("Save"),
                ),
              ],
            ),
          );

          if (hours != null && hours > 0) {
            viewModel.addEntry(SleepEntry(date: today, hours: hours));
          }
        },
        label: const Text("Add Sleep"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

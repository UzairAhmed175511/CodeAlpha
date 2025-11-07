import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker_app/view_models/fitness_view_model.dart';
import 'package:fitness_tracker_app/view_models/insights_view_model.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<FitnessViewModel>().entries;
    final insights = InsightsViewModel(entries);

    return Scaffold(
      appBar: AppBar(title: const Text("Health Insights")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Smart Health Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInsightCard(
              "Average Steps",
              insights.avgSteps.toStringAsFixed(0),
            ),
            _buildInsightCard(
              "Avg Calories Burned",
              insights.avgCalories.toStringAsFixed(1),
            ),
            _buildInsightCard(
              "Avg Workout (min)",
              insights.avgWorkoutMinutes.toStringAsFixed(1),
            ),
            const SizedBox(height: 30),
            Text(
              "Your Health Score: ${insights.healthScore.toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: insights.healthScore > 70
                    ? Colors.green
                    : insights.healthScore > 40
                    ? Colors.orange
                    : Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

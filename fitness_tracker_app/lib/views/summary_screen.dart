import 'package:fl_chart/fl_chart.dart';
import 'package:fitness_tracker_app/view_models/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FitnessViewModel>(context);

    if (viewModel.entries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Summary')),
        body: Center(child: Text('No data yet. Add your fitness entries!')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Summary')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.black, Colors.teal.shade900]
                : [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                "Weekly Progress",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              _buildProgressCard(
                title: "Total Steps",
                value: viewModel.totalSteps.toDouble(),
                goal: 70000,
                unit: "steps",
              ),
              const SizedBox(height: 12),
              _buildProgressCard(
                title: "Calories Burned",
                value: viewModel.totalCalories,
                goal: 3500,
                unit: "kcal",
              ),
              const SizedBox(height: 25),
              const Text(
                "Daily Steps Trend",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Animated chart
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(enabled: true),
                    alignment: BarChartAlignment.spaceAround,
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= viewModel.entries.length)
                              return const SizedBox();
                            final date = viewModel.entries[i].date
                                .split('-')
                                .last;
                            return Text(
                              date,
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      viewModel.entries.takeLast(7).length,
                      (i) {
                        final e = viewModel.entries.takeLast(7)[i];
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: e.steps.toDouble(),
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.indigoAccent,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 600),
                  swapAnimationCurve: Curves.easeInOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required double value,
    required double goal,
    required String unit,
  }) {
    double percent = (value / goal).clamp(0, 1);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            Text(
              "${value.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} $unit",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

extension _TakeLast<E> on List<E> {
  List<E> takeLast(int n) => length <= n ? this : sublist(length - n);
}

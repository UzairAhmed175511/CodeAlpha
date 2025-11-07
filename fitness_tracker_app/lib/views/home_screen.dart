import 'package:fitness_tracker_app/neonAddButton.dart';
import 'package:fitness_tracker_app/view_models/fitness_view_model.dart';
import 'package:fitness_tracker_app/views/calorie_burn_screen.dart';

import 'package:fitness_tracker_app/views/insights_screen.dart';
import 'package:fitness_tracker_app/views/nutrition_screen.dart';
import 'package:fitness_tracker_app/views/sleep_screen.dart';
import 'package:fitness_tracker_app/views/water_screen.dart';
import 'package:fitness_tracker_app/widgets/motivation_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'add_entry_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;

  // late String _dailyQuote;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FitnessViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SummaryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.water_drop, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WaterScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bedtime, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SleepScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restaurant_menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NutritionScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.local_fire_department, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalorieBurnScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InsightsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDEE9FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Lottie.asset(
                    'assets/animations/Run_Loading.json',
                    height: 80,
                    repeat: true,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back 👋",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Here’s your latest fitness progress!",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const MotivationSlider(),

            const SizedBox(height: 20),

            _buildAnimatedStatCard(
              "Total Steps",
              "${viewModel.totalSteps}",
              Icons.directions_walk,
              Colors.indigo,
            ),
            _buildAnimatedStatCard(
              "Calories Burned",
              "${viewModel.totalCalories.toStringAsFixed(1)} kcal",
              Icons.local_fire_department,
              Colors.orangeAccent,
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "Recent Entries",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            ...viewModel.entries.map((e) {
              // Pick icon and color dynamically
              final activityIcon = _getActivityIcon(e.activity);
              final activityColor = _getActivityColor(e.activity);

              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: activityColor.withOpacity(0.2),
                    child: Icon(activityIcon, color: activityColor),
                  ),
                  title: Text(
                    "${e.activity} • ${e.calories.toStringAsFixed(1)} kcal",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Duration: ${e.workoutMinutes} min • ${e.date}",
                  ),
                ),
              );
            }),
          ],
        ),
      ),

      // 🟣 Glowing Hover Button
      floatingActionButton: MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final scale = 1 + _hoverController.value;
            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: NeonAddButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddEntryScreen()),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0, end: 1),
      builder: (context, opacity, child) => Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - opacity)),
          child: child,
        ),
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activity) {
    switch (activity.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'cycling':
        return Icons.directions_bike;
      case 'swimming':
        return Icons.pool;
      case 'yoga':
        return Icons.self_improvement;
      case 'walking':
        return Icons.directions_walk;
      default:
        return Icons.fitness_center;
    }
  }

  Color _getActivityColor(String activity) {
    switch (activity.toLowerCase()) {
      case 'running':
        return Colors.redAccent;
      case 'cycling':
        return Colors.orangeAccent;
      case 'swimming':
        return Colors.teal;
      case 'yoga':
        return Colors.purpleAccent;
      case 'walking':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}

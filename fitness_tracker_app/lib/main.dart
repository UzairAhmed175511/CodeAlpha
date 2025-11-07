import 'package:fitness_tracker_app/models/sleep_entry.dart';
import 'package:fitness_tracker_app/view_models/sleep_view_model.dart';
import 'package:fitness_tracker_app/models/nutrition_entry.dart';
import 'package:fitness_tracker_app/view_models/nutrition_view_model.dart';

import 'package:fitness_tracker_app/models/water_entry.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// MODELS
import 'package:fitness_tracker_app/models/fitness_entry.dart';

// VIEW MODELS
import 'package:fitness_tracker_app/view_models/fitness_view_model.dart';
import 'package:fitness_tracker_app/view_models/water_view_model.dart';

// VIEWS
import 'package:fitness_tracker_app/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(FitnessEntryAdapter());
  Hive.registerAdapter(WaterEntryAdapter()); // ✅ Make sure this is imported
  Hive.registerAdapter(NutritionEntryAdapter());
  Hive.registerAdapter(SleepEntryAdapter());

  await Hive.openBox<FitnessEntry>('fitnessbox');
  await Hive.openBox<WaterEntry>('waterbox'); // ✅ open water box too
  await Hive.openBox<SleepEntry>('sleepbox');
  await Hive.openBox<NutritionEntry>('nutritionbox');

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FitnessViewModel()),
        ChangeNotifierProvider(create: (_) => WaterViewModel()),
        ChangeNotifierProvider(create: (_) => SleepViewModel()),
        ChangeNotifierProvider(create: (_) => NutritionViewModel()),
      ],
      child: const FitnessTrackerApp(),
    ),
  );
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Auto light/dark mode

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.purpleAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.deepPurple.withOpacity(0.2),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 6,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 15),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
          elevation: 6,
          shadowColor: Colors.tealAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1A1C),
          elevation: 8,
          shadowColor: Colors.tealAccent.withOpacity(0.4),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fitness_tracker_app/models/fitness_entry.dart';

class InsightsViewModel extends ChangeNotifier {
  final List<FitnessEntry> _entries;

  InsightsViewModel(this._entries);

  double get avgSteps {
    if (_entries.isEmpty) return 0;
    return _entries.map((e) => e.steps).reduce((a, b) => a + b) /
        _entries.length;
  }

  double get avgCalories {
    if (_entries.isEmpty) return 0;
    return _entries.map((e) => e.calories).reduce((a, b) => a + b) /
        _entries.length;
  }

  double get avgWorkoutMinutes {
    if (_entries.isEmpty) return 0;
    return _entries.map((e) => e.workoutMinutes).reduce((a, b) => a + b) /
        _entries.length;
  }

  double get healthScore {
    if (_entries.isEmpty) return 0;
    double stepScore = (avgSteps / 7000).clamp(0, 1);
    double calScore = (avgCalories / 400).clamp(0, 1);
    double workoutScore = (avgWorkoutMinutes / 45).clamp(0, 1);
    return ((stepScore + calScore + workoutScore) / 3) * 100;
  }
}

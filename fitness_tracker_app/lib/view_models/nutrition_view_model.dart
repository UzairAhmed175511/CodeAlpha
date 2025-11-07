import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/nutrition_entry.dart';

class NutritionViewModel extends ChangeNotifier {
  final _box = Hive.box<NutritionEntry>('nutritionbox');

  List<NutritionEntry> get entries => _box.values.toList();

  int get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);

  void addEntry(NutritionEntry entry) async {
    await _box.add(entry);
    notifyListeners();
  }

  void clearAll() async {
    await _box.clear();
    notifyListeners();
  }
}

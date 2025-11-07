import 'package:flutter/material.dart';
import '../models/fitness_entry.dart';
import '../services/local_storage_service.dart';

class FitnessViewModel extends ChangeNotifier {
  final _storageService = LocalStorageService();
  List<FitnessEntry> entries = [];

  Future<void> loadEntries() async {
    entries = await _storageService.getAllEntries();
    notifyListeners();
  }

  Future<void> addEntry(FitnessEntry entry) async {
    await _storageService.addEntry(entry);

    await loadEntries();
  }

  double get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);
  int get totalSteps => entries.fold(0, (sum, e) => sum + e.steps);
}

import 'package:fitness_tracker_app/models/water_entry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WaterViewModel extends ChangeNotifier {
  final String _boxName = 'waterbox';
  List<WaterEntry> _entries = [];

  List<WaterEntry> get entries => _entries;
  int get totalGlasses => _entries.fold(0, (sum, e) => sum + e.glasses);
  double get totalLiters => totalGlasses * 0.25; // 250ml per glass

  WaterViewModel() {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final box = await Hive.openBox<WaterEntry>(_boxName);
    _entries = box.values.toList();
    notifyListeners();
  }

  Future<void> addEntry(WaterEntry entry) async {
    final box = await Hive.openBox<WaterEntry>(_boxName);
    await box.add(entry);
    _entries.add(entry);
    notifyListeners();
  }

  Future<void> clearEntries() async {
    final box = await Hive.openBox<WaterEntry>(_boxName);
    await box.clear();
    _entries.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/sleep_entry.dart';

class SleepViewModel extends ChangeNotifier {
  final _box = Hive.box<SleepEntry>('sleepbox');

  List<SleepEntry> get entries => _box.values.toList();

  double get totalSleep => entries.fold(0.0, (sum, e) => sum + e.hours);

  double get averageSleep =>
      entries.isEmpty ? 0.0 : totalSleep / entries.length;

  void addEntry(SleepEntry entry) async {
    await _box.add(entry);
    notifyListeners();
  }

  void clearAll() async {
    await _box.clear();
    notifyListeners();
  }
}

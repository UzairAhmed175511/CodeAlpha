import 'package:hive/hive.dart';
import '../models/fitness_entry.dart';

class LocalStorageService {
  static const String boxName = 'fitnessBox';

  Future<void> addEntry(FitnessEntry entry) async {
    final box = await Hive.openBox<FitnessEntry>(boxName);
    await box.add(entry);
  }

  Future<List<FitnessEntry>> getAllEntries() async {
    final box = await Hive.openBox<FitnessEntry>(boxName);
    return box.values.toList();
  }
}

import 'package:hive/hive.dart';

part 'water_entry.g.dart'; // 👈 must be exactly like this

@HiveType(typeId: 2)
class WaterEntry {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final int glasses; // 1 glass = 250ml

  WaterEntry({required this.date, required this.glasses});
}

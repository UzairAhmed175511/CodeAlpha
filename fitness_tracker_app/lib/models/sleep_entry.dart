import 'package:hive/hive.dart';

part 'sleep_entry.g.dart';

@HiveType(typeId: 3)
class SleepEntry {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final double hours; // sleep hours for that date

  SleepEntry({required this.date, required this.hours});
}

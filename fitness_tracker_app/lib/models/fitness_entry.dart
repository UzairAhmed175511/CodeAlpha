import 'package:hive/hive.dart';

part 'fitness_entry.g.dart';

@HiveType(typeId: 0)
class FitnessEntry extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  int steps;

  @HiveField(2)
  double calories;

  @HiveField(3)
  double workoutMinutes;

  @HiveField(4)
  final String activity;

  FitnessEntry({
    required this.date,
    required this.steps,
    required this.calories,
    required this.workoutMinutes,
    required this.activity,
  });
}

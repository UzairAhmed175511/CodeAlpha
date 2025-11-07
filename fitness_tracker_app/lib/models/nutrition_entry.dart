import 'package:hive/hive.dart';

part 'nutrition_entry.g.dart';

@HiveType(typeId: 4)
class NutritionEntry {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String meal;

  @HiveField(2)
  final int calories;

  NutritionEntry({
    required this.date,
    required this.meal,
    required this.calories,
  });
}

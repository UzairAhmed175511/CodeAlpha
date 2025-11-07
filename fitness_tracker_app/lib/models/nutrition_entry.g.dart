// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutritionEntryAdapter extends TypeAdapter<NutritionEntry> {
  @override
  final int typeId = 4;

  @override
  NutritionEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionEntry(
      date: fields[0] as String,
      meal: fields[1] as String,
      calories: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NutritionEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.meal)
      ..writeByte(2)
      ..write(obj.calories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

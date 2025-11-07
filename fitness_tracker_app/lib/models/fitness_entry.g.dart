// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FitnessEntryAdapter extends TypeAdapter<FitnessEntry> {
  @override
  final int typeId = 0;

  @override
  FitnessEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FitnessEntry(
      date: fields[0] as String,
      steps: fields[1] as int,
      calories: fields[2] as double,
      workoutMinutes: fields[3] as double,
      activity: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FitnessEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.steps)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.workoutMinutes)
      ..writeByte(4)
      ..write(obj.activity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

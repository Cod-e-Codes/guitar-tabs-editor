// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guitar_tab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuitarTabAdapter extends TypeAdapter<GuitarTab> {
  @override
  final int typeId = 0;

  @override
  GuitarTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuitarTab(
      name: fields[0] as String,
      content: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GuitarTab obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuitarTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeminiUserModelAdapter extends TypeAdapter<GeminiUserModel> {
  @override
  final int typeId = 1;

  @override
  GeminiUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeminiUserModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeminiUserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeminiUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

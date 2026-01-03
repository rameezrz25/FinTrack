// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetHiveModelAdapter extends TypeAdapter<AssetHiveModel> {
  @override
  final int typeId = 0;

  @override
  AssetHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssetHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      quantity: fields[3] as double,
      purchasePrice: fields[4] as double,
      currentPrice: fields[5] as double,
      purchaseDate: fields[6] as DateTime,
      currency: fields[7] as String,
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AssetHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.currentPrice)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

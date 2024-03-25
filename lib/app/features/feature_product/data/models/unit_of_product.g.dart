// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_of_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitOfProductAdapter extends TypeAdapter<UnitOfProduct> {
  @override
  final int typeId = 15;

  @override
  UnitOfProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitOfProduct(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitOfProduct obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitOfProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitOfProduct _$UnitOfProductFromJson(Map<String, dynamic> json) =>
    UnitOfProduct(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UnitOfProductToJson(UnitOfProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

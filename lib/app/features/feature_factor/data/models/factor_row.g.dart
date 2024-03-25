// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_row.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactorRowAdapter extends TypeAdapter<FactorRow> {
  @override
  final int typeId = 11;

  @override
  FactorRow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FactorRow(
      fields[3] as int,
      productName: fields[0] as String,
      productCount: fields[1] as double,
      productPrice: fields[2] as int,
      productUnit: fields[4] as String,
      priceOfBuy: fields[5] as int?,
      priceOfOneSale: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FactorRow obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.productCount)
      ..writeByte(2)
      ..write(obj.productPrice)
      ..writeByte(3)
      ..write(obj._productSum)
      ..writeByte(4)
      ..write(obj.productUnit)
      ..writeByte(5)
      ..write(obj.priceOfBuy)
      ..writeByte(6)
      ..write(obj.priceOfOneSale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactorRowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorRow _$FactorRowFromJson(Map<String, dynamic> json) {
  return FactorRow(
    json['productSum'] as int,
    productName: json['productName'] as String,
    productCount: json['productCount'] as double,
    productPrice: json['productPrice'] as int,
    productUnit: json['productUnit'] as String,
    priceOfBuy: json['priceOfBuy'] as int?,
    priceOfOneSale: json['priceOfOneSale'] as int?,
  );
}

Map<String, dynamic> _$FactorRowToJson(FactorRow instance) => <String, dynamic>{
  'productSum': instance._productSum,
  'productName': instance.productName,
  'productCount': instance.productCount,
  'productPrice': instance.productPrice,
  'productUnit': instance.productUnit,
  'priceOfOneSale':instance.priceOfOneSale,
  'priceOfBuy':instance.priceOfBuy,
};

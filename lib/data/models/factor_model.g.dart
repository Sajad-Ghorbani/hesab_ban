// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactorAdapter extends TypeAdapter<Factor> {
  @override
  final int typeId = 6;

  @override
  Factor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Factor(
      id: fields[0] as int?,
      customer: fields[1] as Customer?,
      factorDate: fields[2] as DateTime?,
      factorRows: (fields[3] as List?)?.cast<FactorRow>(),
      factorSum: fields[4] as int?,
      typeOfFactor: fields[5] as TypeOfFactor?,
    );
  }

  @override
  void write(BinaryWriter writer, Factor obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.factorDate)
      ..writeByte(3)
      ..write(obj.factorRows)
      ..writeByte(4)
      ..write(obj.factorSum)
      ..writeByte(5)
      ..write(obj.typeOfFactor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TypeOfFactorAdapter extends TypeAdapter<TypeOfFactor> {
  @override
  final int typeId = 10;

  @override
  TypeOfFactor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TypeOfFactor.sale;
      case 1:
        return TypeOfFactor.buy;
      case 2:
        return TypeOfFactor.oneSale;
      case 3:
        return TypeOfFactor.returnOfBuy;
      case 4:
        return TypeOfFactor.returnOfSale;
      default:
        return TypeOfFactor.sale;
    }
  }

  @override
  void write(BinaryWriter writer, TypeOfFactor obj) {
    switch (obj) {
      case TypeOfFactor.sale:
        writer.writeByte(0);
        break;
      case TypeOfFactor.buy:
        writer.writeByte(1);
        break;
      case TypeOfFactor.oneSale:
        writer.writeByte(2);
        break;
      case TypeOfFactor.returnOfBuy:
        writer.writeByte(3);
        break;
      case TypeOfFactor.returnOfSale:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeOfFactorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Factor _$FactorFromJson(Map<String, dynamic> json) => Factor(
      id: json['id'] as int?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      factorDate: json['factorDate'] == null
          ? null
          : DateTime.parse(json['factorDate'] as String),
      factorRows: (json['factorRows'] as List<dynamic>?)
          ?.map((e) => FactorRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      factorSum: json['factorSum'] as int?,
      typeOfFactor:
          $enumDecodeNullable(_$TypeOfFactorEnumMap, json['typeOfFactor']),
    );

Map<String, dynamic> _$FactorToJson(Factor instance) => <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer?.toJson(),
      'factorDate': instance.factorDate?.toIso8601String(),
      'factorRows': instance.factorRows?.map((e) => e.toJson()).toList(),
      'factorSum': instance.factorSum,
      'typeOfFactor': _$TypeOfFactorEnumMap[instance.typeOfFactor],
    };

const _$TypeOfFactorEnumMap = {
  TypeOfFactor.sale: 'sale',
  TypeOfFactor.buy: 'buy',
  TypeOfFactor.oneSale: 'oneSale',
  TypeOfFactor.returnOfBuy: 'returnOfBuy',
  TypeOfFactor.returnOfSale: 'returnOfSale',
};

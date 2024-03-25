// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CashAdapter extends TypeAdapter<Cash> {
  @override
  final int typeId = 12;

  @override
  Cash read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cash(
      id: fields[2] as int?,
      cashAmount: fields[0] as int?,
      cashDate: fields[1] as DateTime?,
      cashCustomer: fields[3] as Customer?,
      factorId: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Cash obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(0)
      ..write(obj.cashAmount)
      ..writeByte(1)
      ..write(obj.cashDate)
      ..writeByte(3)
      ..write(obj.cashCustomer)
      ..writeByte(4)
      ..write(obj.factorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cash _$CashFromJson(Map<String, dynamic> json) => Cash(
      id: json['id'] as int?,
      cashAmount: json['cashAmount'] as int?,
      cashDate: json['cashDate'] == null
          ? null
          : DateTime.parse(json['cashDate'] as String),
      cashCustomer: json['cashCustomer'] == null
          ? null
          : Customer.fromJson(json['cashCustomer'] as Map<String, dynamic>),
      factorId: json['factorId'] as int?,
    );

Map<String, dynamic> _$CashToJson(Cash instance) => <String, dynamic>{
      'id': instance.id,
      'cashAmount': instance.cashAmount,
      'cashDate': instance.cashDate?.toIso8601String(),
      'cashCustomer': instance.cashCustomer?.toJson(),
      'factorId': instance.factorId,
    };

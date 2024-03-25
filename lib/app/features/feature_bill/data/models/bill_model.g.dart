// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 7;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      id: fields[0] as int?,
      customer: fields[1] as Customer?,
      factor: (fields[2] as List?)?.cast<Factor>(),
      check: (fields[3] as List?)?.cast<Check>(),
      cash: (fields[4] as List?)?.cast<Cash>(),
      cashPayment: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.factor)
      ..writeByte(3)
      ..write(obj.check)
      ..writeByte(4)
      ..write(obj.cash)
      ..writeByte(5)
      ..write(obj.cashPayment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      id: json['id'] as int?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      factor: (json['factor'] as List<dynamic>?)
          ?.map((e) => Factor.fromJson(e as Map<String, dynamic>))
          .toList(),
      check: (json['check'] as List<dynamic>?)
          ?.map((e) => Check.fromJson(e as Map<String, dynamic>))
          .toList(),
      cash: (json['cash'] as List<dynamic>?)
          ?.map((e) => Cash.fromJson(e as Map<String, dynamic>))
          .toList(),
      cashPayment: json['cashPayment'] as int? ?? 0,
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer?.toJson(),
      'factor': instance.factor?.map((e) => e.toJson()).toList(),
      'check': instance.check?.map((e) => e.toJson()).toList(),
      'cash': instance.cash?.map((e) => e.toJson()).toList(),
      'cashPayment': instance.cashPayment,
    };

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
      cashAmount: fields[0] as int?,
      cashDate: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Cash obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cashAmount)
      ..writeByte(1)
      ..write(obj.cashDate);
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
      cashAmount: json['cashAmount'] as int?,
      cashDate: json['cashDate'] == null
          ? null
          : DateTime.parse(json['cashDate'] as String),
    );

Map<String, dynamic> _$CashToJson(Cash instance) => <String, dynamic>{
      'cashAmount': instance.cashAmount,
      'cashDate': instance.cashDate?.toIso8601String(),
    };

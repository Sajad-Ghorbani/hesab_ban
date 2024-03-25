// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckAdapter extends TypeAdapter<Check> {
  @override
  final int typeId = 5;

  @override
  Check read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Check(
      id: fields[0] as int?,
      bankName: fields[1] as String?,
      checkNumber: fields[2] as String?,
      customerCheck: fields[3] as Customer?,
      checkAmount: fields[4] as int?,
      checkDueDate: fields[5] as DateTime?,
      checkDeliveryDate: fields[6] as DateTime?,
      typeOfCheck: fields[7] as TypeOfCheck?,
      checkBank: fields[8] as Bank?,
      factorId: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Check obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bankName)
      ..writeByte(2)
      ..write(obj.checkNumber)
      ..writeByte(3)
      ..write(obj.customerCheck)
      ..writeByte(4)
      ..write(obj.checkAmount)
      ..writeByte(5)
      ..write(obj.checkDueDate)
      ..writeByte(6)
      ..write(obj.checkDeliveryDate)
      ..writeByte(7)
      ..write(obj.typeOfCheck)
      ..writeByte(8)
      ..write(obj.checkBank)
      ..writeByte(9)
      ..write(obj.factorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TypeOfCheckAdapter extends TypeAdapter<TypeOfCheck> {
  @override
  final int typeId = 9;

  @override
  TypeOfCheck read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TypeOfCheck.send;
      case 1:
        return TypeOfCheck.received;
      default:
        return TypeOfCheck.send;
    }
  }

  @override
  void write(BinaryWriter writer, TypeOfCheck obj) {
    switch (obj) {
      case TypeOfCheck.send:
        writer.writeByte(0);
        break;
      case TypeOfCheck.received:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeOfCheckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Check _$CheckFromJson(Map<String, dynamic> json) => Check(
      id: json['id'] as int?,
      bankName: json['bankName'] as String?,
      checkNumber: json['checkNumber'] as String?,
      customerCheck: json['customerCheck'] == null
          ? null
          : Customer.fromJson(json['customerCheck'] as Map<String, dynamic>),
      checkAmount: json['checkAmount'] as int?,
      checkDueDate: json['checkDueDate'] == null
          ? null
          : DateTime.parse(json['checkDueDate'] as String),
      checkDeliveryDate: json['checkDeliveryDate'] == null
          ? null
          : DateTime.parse(json['checkDeliveryDate'] as String),
      typeOfCheck:
          $enumDecodeNullable(_$TypeOfCheckEnumMap, json['typeOfCheck']),
      checkBank: json['checkBank'] == null
          ? null
          : Bank.fromJson(json['checkBank'] as Map<String, dynamic>),
      factorId: json['factorId'] as int?,
    );

Map<String, dynamic> _$CheckToJson(Check instance) => <String, dynamic>{
      'id': instance.id,
      'bankName': instance.bankName,
      'checkNumber': instance.checkNumber,
      'customerCheck': instance.customerCheck?.toJson(),
      'checkAmount': instance.checkAmount,
      'checkDueDate': instance.checkDueDate?.toIso8601String(),
      'checkDeliveryDate': instance.checkDeliveryDate?.toIso8601String(),
      'typeOfCheck': _$TypeOfCheckEnumMap[instance.typeOfCheck],
      'checkBank': instance.checkBank?.toJson(),
      'factorId': instance.factorId,
    };

const _$TypeOfCheckEnumMap = {
  TypeOfCheck.send: 'send',
  TypeOfCheck.received: 'received',
};

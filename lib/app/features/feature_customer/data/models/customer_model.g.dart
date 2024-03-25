// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 4;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      id: fields[0] as int?,
      name: fields[1] as String?,
      address: fields[2] as String?,
      phoneNumber1: fields[3] as String?,
      phoneNumber2: fields[4] as String?,
      initialAccountBalance: fields[5] as int?,
      description: fields[6] as String?,
      isActive: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phoneNumber1)
      ..writeByte(4)
      ..write(obj.phoneNumber2)
      ..writeByte(5)
      ..write(obj.initialAccountBalance)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phoneNumber1: json['phoneNumber1'] as String?,
      phoneNumber2: json['phoneNumber2'] as String?,
      initialAccountBalance: json['initialAccountBalance'] as int?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber1': instance.phoneNumber1,
      'phoneNumber2': instance.phoneNumber2,
      'initialAccountBalance': instance.initialAccountBalance,
      'description': instance.description,
      'isActive': instance.isActive,
    };

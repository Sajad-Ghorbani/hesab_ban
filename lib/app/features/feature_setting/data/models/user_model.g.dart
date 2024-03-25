// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      name: fields[1] as String?,
      phoneNumber: fields[2] as String?,
      storeAddress: fields[3] as String?,
      storeName: fields[4] as String?,
      storeLogo: fields[5] as String?,
      userEmail: fields[6] as String?,
      hashedPassword: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.storeAddress)
      ..writeByte(4)
      ..write(obj.storeName)
      ..writeByte(5)
      ..write(obj.storeLogo)
      ..writeByte(6)
      ..write(obj.userEmail)
      ..writeByte(7)
      ..write(obj.hashedPassword);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      storeAddress: json['storeAddress'] as String?,
      storeName: json['storeName'] as String?,
      storeLogo: json['storeLogo'] as String?,
      userEmail: json['userEmail'] as String?,
      hashedPassword: json['hashedPassword'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'storeAddress': instance.storeAddress,
      'storeName': instance.storeName,
      'storeLogo': instance.storeLogo,
      'userEmail': instance.userEmail,
      'hashedPassword': instance.hashedPassword,
    };

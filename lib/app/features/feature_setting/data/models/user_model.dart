import 'package:hesab_ban/app/features/feature_setting/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  String? storeAddress;

  @HiveField(4)
  String? storeName;

  @HiveField(5)
  String? storeLogo;

  @HiveField(6)
  String? userEmail;

  @HiveField(7)
  String? hashedPassword;

  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.storeAddress,
    this.storeName,
    this.storeLogo,
    this.userEmail,
    this.hashedPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromEntity(UserEntity user) {
    return User(
      id: user.id,
      name: user.name,
      phoneNumber: user.phoneNumber,
      storeLogo: user.storeLogo,
      storeName: user.storeName,
      storeAddress: user.storeAddress,
      userEmail: user.userEmail,
      hashedPassword: user.hashedPassword,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      storeName: storeName,
      storeLogo: storeLogo,
      storeAddress: storeAddress,
      userEmail: userEmail,
      hashedPassword: hashedPassword,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, phoneNumber: $phoneNumber, storeAddress: $storeAddress, storeName: $storeName, storeLogo: $storeLogo, userEmail: $userEmail, hashedPassword: $hashedPassword}';
  }
}

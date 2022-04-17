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
  String? address;

  @HiveField(3)
  String? storeName;

  @HiveField(4)
  String? phoneNumber;

  User({this.id, this.name, this.address, this.storeName, this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
// User.fromJson(Map<String, dynamic> json) {
//   id = json['id'];
//   name = json['name'];
//   address = json['address'];
//   storeName = json['store_name'];
//   phoneNumber = json['phone_number'];
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = {};
//   data['id'] = id;
//   data['name'] = name;
//   data['address'] = address;
//   data['store_name'] = storeName;
//   data['phone_number'] = phoneNumber;
//   return data;
// }
}

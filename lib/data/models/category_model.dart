import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class Category extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
  // Category.fromJson(Map<String, dynamic> json){
  //   id = json['id'];
  //   name = json['name'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   data['id'] = id;
  //   data['name'] = name;
  //   return data;
  // }
}

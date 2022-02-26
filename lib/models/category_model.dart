import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 8)
class Category extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

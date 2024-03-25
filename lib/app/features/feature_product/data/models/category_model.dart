import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
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

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  CategoryEntity toEntity() {
    return CategoryEntity(id: id, name: name);
  }

  factory Category.fromEntity(CategoryEntity categoryEntity) {
    return Category(id: categoryEntity.id, name: categoryEntity.name);
  }
}

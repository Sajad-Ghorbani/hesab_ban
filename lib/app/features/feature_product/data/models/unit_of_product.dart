import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unit_of_product.g.dart';

@JsonSerializable()
@HiveType(typeId: 15)
class UnitOfProduct extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  UnitOfProduct({this.id, this.name});

  factory UnitOfProduct.fromJson(Map<String, dynamic> json) =>
      _$UnitOfProductFromJson(json);

  Map<String, dynamic> toJson() => _$UnitOfProductToJson(this);

  factory UnitOfProduct.fromEntity(UnitOfProductEntity entity) {
    return UnitOfProduct(
      id: entity.id,
      name: entity.name,
    );
  }

  UnitOfProductEntity toEntity() {
    return UnitOfProductEntity(
      name: name,
      id: id,
    );
  }

  @override
  String toString() {
    return 'id => $id, name => $name ';
  }
}

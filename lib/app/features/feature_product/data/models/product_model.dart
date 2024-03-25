import 'package:hesab_ban/app/features/feature_product/data/models/category_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/unit_of_product.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  int? priceOfBuy;

  @HiveField(3)
  int? priceOfOneSale;

  @HiveField(4)
  int? priceOfMajorSale;

  @HiveField(5)
  Unit? mainUnit;

  @HiveField(6)
  Unit? subCountingUnit;

  @HiveField(10)
  UnitOfProduct? mainUnitOfProduct;

  @HiveField(11)
  UnitOfProduct? subCountingUnitOfProduct;

  @HiveField(7)
  double? count;

  @HiveField(8)
  double? unitRatio;

  @HiveField(9)
  Category? category;

  Product({
    this.id,
    this.name,
    this.priceOfBuy,
    this.priceOfOneSale,
    this.priceOfMajorSale,
    this.mainUnit,
    this.subCountingUnit,
    this.mainUnitOfProduct,
    this.subCountingUnitOfProduct,
    this.count,
    this.unitRatio,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  factory Product.fromEntity(ProductEntity productEntity) {
    return Product(
      id: productEntity.id,
      name: productEntity.name,
      priceOfBuy: productEntity.priceOfBuy,
      priceOfOneSale: productEntity.priceOfOneSale,
      priceOfMajorSale: productEntity.priceOfMajorSale,
      mainUnitOfProduct: productEntity.mainUnit == null
          ? null
          : UnitOfProduct.fromEntity(productEntity.mainUnit!),
      subCountingUnitOfProduct: productEntity.subCountingUnit == null
          ? null
          : UnitOfProduct.fromEntity(productEntity.subCountingUnit!),
      count: productEntity.count,
      unitRatio: productEntity.unitRatio,
      category: productEntity.category == null
          ? null
          : Category.fromEntity(productEntity.category!),
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      priceOfBuy: priceOfBuy,
      priceOfOneSale: priceOfOneSale,
      priceOfMajorSale: priceOfMajorSale,
      mainUnit: mainUnitOfProduct?.toEntity(),
      subCountingUnit: subCountingUnitOfProduct?.toEntity(),
      count: count,
      category: category?.toEntity(),
      unitRatio: unitRatio,
    );
  }

  @override
  toString() =>
      '(id: $id, name: $name, priceOfBuy: $priceOfBuy, priceOfOneSale: $priceOfOneSale, priceOfMajorSale: $priceOfMajorSale, mainUnitOfProduct: $mainUnitOfProduct, count: $count)';
}

/// This enum is deprecated, but because it is used in [Product] model,it cannot
/// be deleted and removed from the database. If it is removed from [Product],
/// [Product] is changed and you get an error to register typeId.
@Deprecated('Use [UnitOfProduct]')
@HiveType(typeId: 3)
enum Unit {
  @HiveField(0, defaultValue: true)
  number,

  @HiveField(1)
  packet,

  @HiveField(2)
  meter,

  @HiveField(3)
  squareMeters,

  @HiveField(4)
  box,

  @HiveField(5)
  branch,
}
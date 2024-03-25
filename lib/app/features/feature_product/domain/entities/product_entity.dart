import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';

class ProductEntity {
  final int? id;
  final String? name;
  final int? priceOfBuy;
  final int? priceOfOneSale;
  final int? priceOfMajorSale;
  final UnitOfProductEntity? mainUnit;
  final UnitOfProductEntity? subCountingUnit;
  final double? count;
  final double? unitRatio;
  final CategoryEntity? category;

  ProductEntity({
    this.id,
    this.name,
    this.priceOfBuy,
    this.priceOfOneSale,
    this.priceOfMajorSale,
    this.mainUnit,
    this.subCountingUnit,
    this.count,
    this.unitRatio,
    this.category,
  });
}

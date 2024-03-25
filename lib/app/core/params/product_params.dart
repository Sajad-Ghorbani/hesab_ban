import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/unit_of_product_entity.dart';

class ProductParams {
  int? id;
  String? name;
  int? priceOfBuy;
  int? priceOfOneSale;
  int? priceOfMajorSale;
  UnitOfProductEntity? mainUnit;
  UnitOfProductEntity? subCountingUnit;
  double? count;
  double? unitRatio;
  CategoryEntity? category;

  ProductParams({
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

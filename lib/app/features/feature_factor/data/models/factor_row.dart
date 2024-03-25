import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'factor_row.g.dart';

@JsonSerializable()
@HiveType(typeId: 11)
class FactorRow {
  @HiveField(0)
  late String productName;

  @HiveField(1)
  late double productCount;

  @HiveField(2)
  late int productPrice;

  @HiveField(3)
  late int _productSum;

  @HiveField(4)
  late String productUnit;

  @HiveField(5)
  int? priceOfBuy;

  @HiveField(6)
  int? priceOfOneSale;

  int get productSum {
    if (priceOfBuy != null) {
      _productSum = (productCount * priceOfBuy!.toDouble()).toInt();
    } //
    else {
      _productSum = (productCount * productPrice.toDouble()).toInt();
    }
    return _productSum;
  }

  FactorRow(
    this._productSum, {
    required this.productName,
    required this.productCount,
    required this.productPrice,
    required this.productUnit,
    this.priceOfBuy,
    this.priceOfOneSale,
  });

  factory FactorRow.fromJson(Map<String, dynamic> json) =>
      _$FactorRowFromJson(json);

  Map<String, dynamic> toJson() => _$FactorRowToJson(this);

  factory FactorRow.fromEntity(FactorRowEntity factorRow) {
    return FactorRow(
      factorRow.productSum,
      productName: factorRow.productName,
      productCount: factorRow.productCount,
      productPrice: factorRow.productPriceOfSale,
      productUnit: factorRow.productUnit,
      priceOfBuy: factorRow.priceOfBuy,
      priceOfOneSale: factorRow.priceOfOneSale,
    );
  }

  FactorRowEntity toEntity() {
    return FactorRowEntity(
      productSum,
      productName: productName,
      productCount: productCount,
      productPriceOfSale: productPrice,
      productUnit: productUnit,
      priceOfBuy: priceOfBuy,
      priceOfOneSale: priceOfOneSale,
    );
  }
}

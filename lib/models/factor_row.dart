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

  int get productSum {
    _productSum = (productCount * productPrice.toDouble()).toInt();
    return _productSum;
  }

  FactorRow(
    this._productSum, {
    required this.productName,
    required this.productCount,
    required this.productPrice,
    required this.productUnit,
  });

  factory FactorRow.fromJson(Map<String, dynamic> json) =>
      _$FactorRowFromJson(json);

  Map<String, dynamic> toJson() => _$FactorRowToJson(this);
}

import 'package:hive/hive.dart';

part 'factor_row.g.dart';

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

  FactorRow({
    required this.productName,
    required this.productCount,
    required this.productPrice,
    required this.productUnit,
  });
}

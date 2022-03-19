import 'package:hesab_ban/models/category_model.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

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
    this.count,
    this.unitRatio,
    this.category,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    priceOfBuy = json['price_of_buy'];
    priceOfOneSale = json['price_of_one_sale'];
    priceOfMajorSale = json['price_of_major_sale'];
    mainUnit = json['unit'];
    subCountingUnit = json['sub_counting_unit'];
    count = json['count'];
    unitRatio = json['unit_ratio'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['price_of_buy'] = priceOfBuy;
    data['price_of_one_sale'] = priceOfOneSale;
    data['price_of_major_sale'] = priceOfMajorSale;
    data['unit'] = mainUnit;
    data['sub_counting_unit'] = subCountingUnit;
    data['count'] = count;
    data['unit_ratio'] = unitRatio;
    data['category'] = category;
    return data;
  }
}

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

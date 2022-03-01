import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hive/hive.dart';

part 'factor_model.g.dart';

@HiveType(typeId: 6)
class Factor extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  Customer? customer;

  @HiveField(2)
  DateTime? factorDate;

  @HiveField(3)
  List<Product>? products;

  @HiveField(4)
  int? factorSum;

  @HiveField(5)
  String? factorStatus;

  @HiveField(6)
  TypeOfFactor? typeOfFactor;

  Factor({
    this.id,
    this.customer,
    this.factorDate,
    this.products,
    this.factorSum,
    this.factorStatus,
    this.typeOfFactor,
  });

  Factor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    factorDate = json['factor_date'];
    products = json['products'].cast<Product>();
    factorSum = json['factor_sum'];
    factorStatus = json['factor_status'];
    typeOfFactor = json['type_of_factor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['customer'] = customer;
    data['factor_date'] = factorDate;
    data['products'] = products;
    data['factor_sum'] = factorSum;
    data['factor_status'] = factorStatus;
    data['type_of_factor'] = typeOfFactor;
    return data;
  }
}

enum TypeOfFactor{sell,buy}

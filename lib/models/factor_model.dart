import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/models/factor_row.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'factor_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 6)
class Factor extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  Customer? customer;

  @HiveField(2)
  DateTime? factorDate;

  @HiveField(3)
  List<FactorRow>? factorRows;

  @HiveField(4)
  int? factorSum;

  @HiveField(5)
  TypeOfFactor? typeOfFactor;

  Factor({
    this.id,
    this.customer,
    this.factorDate,
    this.factorRows,
    this.factorSum,
    this.typeOfFactor,
  });

  factory Factor.fromJson(Map<String, dynamic> json) => _$FactorFromJson(json);

  Map<String, dynamic> toJson() => _$FactorToJson(this);
  // Factor.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   customer = json['customer'];
  //   factorDate = json['factor_date'];
  //   factorRows = json['factor_rows'].cast<FactorRow>();
  //   factorSum = json['factor_sum'];
  //   typeOfFactor = json['type_of_factor'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   data['id'] = id;
  //   data['customer'] = customer;
  //   data['factor_date'] = factorDate;
  //   data['factor_rows'] = factorRows;
  //   data['factor_sum'] = factorSum;
  //   data['type_of_factor'] = typeOfFactor;
  //   return data;
  // }
}

@HiveType(typeId: 10)
enum TypeOfFactor {
  @HiveField(0)
  sale,

  @HiveField(1)
  buy,

  @HiveField(2)
  oneSale,

  @HiveField(3)
  returnOfBuy,

  @HiveField(4)
  returnOfSale,
}

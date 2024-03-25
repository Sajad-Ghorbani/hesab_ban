import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_row.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
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

  @HiveField(6)
  List<int>? checksId;

  @HiveField(7)
  List<int>? cashesId;

  @HiveField(8)
  double? tax;

  @HiveField(9)
  double? offer;

  @HiveField(10)
  int? costs;

  @HiveField(11)
  String? costsLabel;

  @HiveField(12)
  String? description;

  Factor({
    this.id,
    this.customer,
    this.factorDate,
    this.factorRows,
    this.factorSum,
    this.typeOfFactor,
    this.checksId,
    this.cashesId,
    this.tax,
    this.offer,
    this.costs,
    this.costsLabel,
    this.description,
  });

  factory Factor.fromJson(Map<String, dynamic> json) => _$FactorFromJson(json);

  Map<String, dynamic> toJson() => _$FactorToJson(this);

  factory Factor.fromEntity(FactorEntity factor) {
    return Factor(
      id: factor.id,
      customer: Customer.fromEntity(factor.customer!),
      factorDate: factor.factorDate,
      factorSum: factor.factorSum,
      typeOfFactor: factor.typeOfFactor,
      factorRows:
          factor.factorRows?.map((e) => FactorRow.fromEntity(e)).toList(),
      checksId: factor.checksId,
      cashesId: factor.cashesId,
      offer: factor.offer,
      tax: factor.tax,
      costs: factor.costs?.cost,
      costsLabel: factor.costs?.label,
      description: factor.description,
    );
  }

  FactorEntity toEntity() {
    return FactorEntity(
      id: id,
      customer: customer!.toEntity(),
      factorRows: factorRows?.map((e) => e.toEntity()).toList(),
      typeOfFactor: typeOfFactor,
      factorSum: factorSum,
      factorDate: factorDate,
      checksId: checksId,
      cashesId: cashesId,
      costs: (cost: costs, label: costsLabel),
      tax: tax,
      offer: offer,
      description: description,
    );
  }
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

import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';

class FactorParams {
  int? id;
  CustomerEntity? customer;
  DateTime? factorDate;
  List<FactorRowEntity>? factorRows;
  int? factorSum;
  String? typeOfFactor;
  List<int>? checksId;
  List<int>? cashesId;
  double? tax;
  double? offer;
  ({String? label, int? cost})? costs;
  String? description;

  FactorParams({
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
    this.description,
  });
}

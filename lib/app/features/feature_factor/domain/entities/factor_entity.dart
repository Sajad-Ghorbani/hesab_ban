import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';

class FactorEntity {
  final int? id;
  CustomerEntity? customer;
  final DateTime? factorDate;
  final List<FactorRowEntity>? factorRows;
  final int? factorSum;
  final TypeOfFactor? typeOfFactor;
  final List<int>? checksId;
  final List<int>? cashesId;
  final double? tax;
  final double? offer;
  final ({String? label, int? cost})? costs;
  final String? description;

  FactorEntity({
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

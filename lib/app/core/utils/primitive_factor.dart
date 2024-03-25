import 'package:equatable/equatable.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_row_entity.dart';
import 'package:collection/collection.dart';

class PrimitiveFactor extends Equatable {
  final CustomerEntity? customer;
  final DateTime? factorDate;
  final List<FactorRowEntity>? factorRows;
  final int? factorSum;
  final double? tax;
  final double? offer;
  final ({String? label, int? cost})? costs;
  final String? description;

  const PrimitiveFactor({
    this.customer,
    this.factorDate,
    this.factorRows,
    this.factorSum,
    this.tax,
    this.offer,
    this.costs,
    this.description,
  });

  factory PrimitiveFactor.fromEntity(FactorEntity factor) {
    return PrimitiveFactor(
      customer: factor.customer,
      factorDate: factor.factorDate,
      factorSum: factor.factorSum!.abs(),
      factorRows: List<FactorRowEntity>.from(factor.factorRows!),
      offer: factor.offer ?? 0,
      tax: factor.tax ?? 0,
      costs: factor.costs?.cost == null ? (label: null, cost: 0) : factor.costs,
      description: factor.description,
    );
  }

  @override
  List<Object?> get props => [
        customer!,
        factorDate!,
        factorRows!,
        factorSum!,
        tax ?? 0,
        offer ?? 0,
        costs ?? (label: null, cost: 0),
        description,
      ];

  Map<String, Object> propsDiffs(Object other) {
    // Create a map of property differences
    Map<String, Object> diffs = {};
    if (other is PrimitiveFactor) {
      if (customer != other.customer) {
        diffs['customer'] = [customer, other.customer];
      }
      if (factorDate != other.factorDate) {
        diffs['factorDate'] = [factorDate, other.factorDate];
      }
      if (!const ListEquality().equals(factorRows, other.factorRows)) {
        diffs['factorRows'] = [factorRows, other.factorRows];
      }
      if (factorSum != other.factorSum) {
        diffs['factorSum'] = [factorSum, other.factorSum];
      }
      if (tax != other.tax) {
        diffs['tax'] = [tax, other.tax];
      }
      if (offer != other.offer) {
        diffs['offer'] = [offer, other.offer];
      }
      if (costs != other.costs) {
        diffs['costs'] = [costs, other.costs];
      }
      if (description != other.description) {
        diffs['description'] = [description, other.description];
      }
    }
    return diffs;
  }
}

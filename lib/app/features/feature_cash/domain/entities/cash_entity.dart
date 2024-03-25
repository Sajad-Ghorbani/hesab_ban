import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';

class CashEntity {
  final int? id;
  final int? cashAmount;
  final DateTime? cashDate;
  final CustomerEntity? customer;
  final int? factorId;

  CashEntity({
    this.id,
    this.cashAmount,
    this.cashDate,
    this.customer,
    this.factorId,
  });
}

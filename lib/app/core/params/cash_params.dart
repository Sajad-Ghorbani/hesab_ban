import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';

class CashParams {
  int? id;
  int? cashAmount;
  DateTime? cashDate;
  CustomerEntity? cashCustomer;
  int? factorId;

  CashParams({
    this.id,
    this.cashAmount,
    this.cashDate,
    this.cashCustomer,
    this.factorId,
  });
}

import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';

class BillParams {
  CustomerEntity? customer;
  FactorEntity? factor;
  CheckEntity? check;
  CashEntity? cash;

  BillParams({
    this.customer,
    this.factor,
    this.check,
    this.cash,
  });
}

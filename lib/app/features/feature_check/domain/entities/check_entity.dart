import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';

class CheckEntity {
  final int? id;
  final String? bankName;
  final String? checkNumber;
  final CustomerEntity? customerCheck;
  final int? checkAmount;
  final DateTime? checkDueDate;
  final DateTime? checkDeliveryDate;
  final TypeOfCheck? typeOfCheck;
  final BankEntity? checkBank;
  final int? factorId;

  CheckEntity({
    this.id,
    this.bankName,
    this.checkNumber,
    this.customerCheck,
    this.checkAmount,
    this.checkDueDate,
    this.checkDeliveryDate,
    this.typeOfCheck,
    this.checkBank,
    this.factorId,
  });
}

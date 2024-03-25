import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';

class CheckParams {
  int? id;
  String? bankName;
  String? checkNumber;
  CustomerEntity? customerCheck;
  int? checkAmount;
  DateTime? checkDueDate;
  DateTime? checkDeliveryDate;
  String? typeOfCheck;
  String? checkBank;
  int? factorId;

  CheckParams({
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

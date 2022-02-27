import 'package:hive/hive.dart';
import 'customer_model.dart';

part 'check_model.g.dart';

@HiveType(typeId: 5)
class Check extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? bankName;

  @HiveField(2)
  String? checkNumber;

  @HiveField(3)
  Customer? customerCheck;

  @HiveField(4)
  int? checkAmount;

  @HiveField(5)
  DateTime? checkDueDate;

  @HiveField(6)
  DateTime? checkDeliveryDate;

  @HiveField(7)
  String? typeOfCheck;

  Check({
    this.id,
    this.bankName,
    this.checkNumber,
    this.customerCheck,
    this.checkAmount,
    this.checkDueDate,
    this.checkDeliveryDate,
    this.typeOfCheck,
  });

  Check.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bank_name'];
    checkNumber = json['check_number'];
    customerCheck = json['customer_check'];
    checkAmount = json['check_amount'];
    checkDueDate = json['check_due_date'];
    checkDeliveryDate = json['check_delivery_date'];
    typeOfCheck = json['type_of_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bank_name'] = bankName;
    data['check_number'] = checkNumber;
    data['customer_check'] = customerCheck;
    data['check_amount'] = checkAmount;
    data['check_due_date'] = checkDueDate;
    data['check_delivery_date'] = checkDeliveryDate;
    data['type_of_check'] = typeOfCheck;
    return data;
  }
}

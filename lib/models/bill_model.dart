import 'package:accounting_app/models/check_model.dart';
import 'package:accounting_app/models/factor_model.dart';
import 'customer_model.dart';
import 'package:hive/hive.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 7)
class Bill extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  Customer? customer;

  @HiveField(2)
  List<Factor>? factor;

  @HiveField(3)
  List<Check>? check;

  @HiveField(4)
  int? cashPayment;

  Bill({this.id, this.customer, this.factor, this.check, this.cashPayment});

  Bill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    factor = json['factor'].cast<Factor>();
    check = json['check'].cast<Check>();
    cashPayment = json['cash_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['customer'] = customer;
    data['factor'] = factor;
    data['check'] = check;
    data['cash_payment'] = cashPayment;
    return data;
  }
}
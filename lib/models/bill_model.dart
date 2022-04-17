import 'package:hesab_ban/models/cash_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'customer_model.dart';
import 'package:hive/hive.dart';

part 'bill_model.g.dart';

@JsonSerializable(explicitToJson: true)
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
  List<Cash>? cash;

  @HiveField(5)
  int _cashPayment = 0;

  int? get cashPayment {
    _cashPayment = customer!.initialAccountBalance!;
    if (factor != null) {
      for (var item in factor!) {
        _cashPayment = _cashPayment + item.factorSum!;
      }
    }
    if (check != null) {
      for (var item in check!) {
        _cashPayment = _cashPayment + item.checkAmount!;
      }
    }
    if (cash != null) {
      for (var item in cash!) {
        _cashPayment = _cashPayment + item.cashAmount!;
      }
    }
    return _cashPayment;
  }

  Bill({this.id, this.customer, this.factor, this.check, this.cash});

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
  // factory Bill.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   customer = json['customer'];
  //   factor = json['factor'].cast<Factor>();
  //   check = json['check'].cast<Check>();
  //   cash = json['cash'].cast<Cash>();
  //   _cashPayment = json['cash_payment'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   data['id'] = id;
  //   data['customer'] = customer;
  //   data['factor'] = factor;
  //   data['check'] = check;
  //   data['cash'] = cash;
  //   data['cash_payment'] = _cashPayment;
  //   return data;
  // }
}

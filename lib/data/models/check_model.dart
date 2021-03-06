import 'package:hesab_ban/data/models/bank_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'customer_model.dart';

part 'check_model.g.dart';

@JsonSerializable(explicitToJson: true)
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
  TypeOfCheck? typeOfCheck;

  @HiveField(8)
  Bank? checkBank;

  Check({
    this.id,
    this.bankName,
    this.checkNumber,
    this.customerCheck,
    this.checkAmount,
    this.checkDueDate,
    this.checkDeliveryDate,
    this.typeOfCheck,
    this.checkBank,
  });

  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);
  //   id = json['id'];
  //   bankName = json['bank_name'];
  //   checkNumber = json['check_number'];
  //   customerCheck = json['customer_check'];
  //   checkAmount = json['check_amount'];
  //   checkDueDate = json['check_due_date'];
  //   checkDeliveryDate = json['check_delivery_date'];
  //   typeOfCheck = json['type_of_check'];
  //   checkBank = json['check_bank'];
  // }

  Map<String, dynamic> toJson() => _$CheckToJson(this);
  //   final Map<String, dynamic> data = {};
  //   data['id'] = id;
  //   data['bank_name'] = bankName;
  //   data['check_number'] = checkNumber;
  //   data['customer_check'] = customerCheck;
  //   data['check_amount'] = checkAmount;
  //   data['check_due_date'] = checkDueDate;
  //   data['check_delivery_date'] = checkDeliveryDate;
  //   data['type_of_check'] = typeOfCheck;
  //   data['check_bank'] = checkBank;
  //   return data;
  // }
}

@HiveType(typeId: 9)
enum TypeOfCheck {
  @HiveField(0)
  send,

  @HiveField(1)
  received,
}

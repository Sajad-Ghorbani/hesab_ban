import 'package:hesab_ban/app/features/feature_check/data/models/bank_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

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

  @HiveField(9)
  int? factorId;

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
    this.factorId,
  });

  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);

  Map<String, dynamic> toJson() => _$CheckToJson(this);

  CheckEntity toEntity() {
    return CheckEntity(
      id: id,
      bankName: bankName,
      checkAmount: checkAmount,
      checkBank: checkBank?.toEntity(),
      checkNumber: checkNumber,
      customerCheck: customerCheck?.toEntity(),
      checkDeliveryDate: checkDeliveryDate,
      checkDueDate: checkDueDate,
      typeOfCheck: typeOfCheck,
      factorId: factorId,
    );
  }

  factory Check.fromEntity(CheckEntity checkEntity) {
    return Check(
      id: checkEntity.id,
      bankName: checkEntity.bankName,
      checkBank: Bank.fromEntity(checkEntity.checkBank!),
      checkAmount: checkEntity.checkAmount,
      typeOfCheck: checkEntity.typeOfCheck,
      checkNumber: checkEntity.checkNumber,
      customerCheck: Customer.fromEntity(checkEntity.customerCheck!),
      checkDueDate: checkEntity.checkDueDate,
      checkDeliveryDate: checkEntity.checkDeliveryDate,
      factorId: checkEntity.factorId,
    );
  }

  @override
  String toString() {
    return 'bank name=> ${checkBank?.name}-- amount=> $checkAmount -- type=> ${typeOfCheck.toString()}-- number=> $checkNumber -- customer=> ${customerCheck?.name}'
        'date=> $checkDueDate ,,, $checkDeliveryDate';
  }
}

@HiveType(typeId: 9)
enum TypeOfCheck {
  @HiveField(0)
  send,
  @HiveField(1)
  received,
}

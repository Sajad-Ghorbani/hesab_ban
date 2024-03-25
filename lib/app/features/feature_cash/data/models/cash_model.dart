import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cash_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 12)
class Cash extends HiveObject {
  @HiveField(2)
  int? id;

  @HiveField(0)
  int? cashAmount;

  @HiveField(1)
  DateTime? cashDate;

  @HiveField(3)
  Customer? cashCustomer;

  @HiveField(4)
  int? factorId;

  Cash({
    this.id,
    this.cashAmount,
    this.cashDate,
    this.cashCustomer,
    this.factorId,
  });

  factory Cash.fromJson(Map<String, dynamic> json) => _$CashFromJson(json);

  Map<String, dynamic> toJson() => _$CashToJson(this);

  CashEntity toEntity() {
    return CashEntity(
      id: id,
      cashAmount: cashAmount,
      cashDate: cashDate,
      customer: cashCustomer?.toEntity(),
      factorId: factorId,
    );
  }

  factory Cash.fromEntity(CashEntity cashEntity) {
    return Cash(
      id: cashEntity.id,
      cashDate: cashEntity.cashDate,
      cashAmount: cashEntity.cashAmount,
      cashCustomer: Customer.fromEntity(cashEntity.customer!),
      factorId: cashEntity.factorId,
    );
  }

  @override
  String toString() {
    return 'id => $id, date => $cashDate, amount => $cashAmount , customer => $cashCustomer , factorId => $factorId';
  }
}

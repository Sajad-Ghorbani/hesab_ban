import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:json_annotation/json_annotation.dart';
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
  int? cashPayment;

  // int? get cashPayment {
  //   _cashPayment = customer!.initialAccountBalance!;
  //   if (factor != null) {
  //     for (var item in factor!) {
  //       _cashPayment = _cashPayment + item.factorSum!;
  //     }
  //   }
  //   if (check != null) {
  //     for (var item in check!) {
  //       _cashPayment = _cashPayment + item.checkAmount!;
  //     }
  //   }
  //   if (cash != null) {
  //     for (var item in cash!) {
  //       _cashPayment = _cashPayment + item.cashAmount!;
  //     }
  //   }
  //   return _cashPayment;
  // }

  Bill({
    this.id,
    this.customer,
    this.factor,
    this.check,
    this.cash,
    this.cashPayment = 0,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);

  factory Bill.fromEntity(BillEntity billEntity) {
    return Bill(
      id: billEntity.id,
      customer: Customer.fromEntity(billEntity.customer!),
      factor: billEntity.factor?.map((e) => Factor.fromEntity(e)).toList(),
      check: billEntity.check?.map((e) => Check.fromEntity(e)).toList(),
      cash: billEntity.cash?.map((e) => Cash.fromEntity(e)).toList(),
      cashPayment: billEntity.cashPayment ?? 0,
    );
  }

  BillEntity toEntity() {
    final BillEntity data = BillEntity();
    data.id = id;
    data.customer = customer!.toEntity();
    data.factor = factor?.map((e) => e.toEntity()).toList();
    data.check = check?.map((e) => e.toEntity()).toList();
    data.cash = cash?.map((e) => e.toEntity()).toList();
    data.cashPayment = cashPayment;
    return data;
  }
}

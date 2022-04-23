import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cash_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 12)
class Cash extends HiveObject {
  @HiveField(0)
  int? cashAmount;

  @HiveField(1)
  DateTime? cashDate;

  Cash({this.cashAmount, this.cashDate});

  factory Cash.fromJson(Map<String, dynamic> json) => _$CashFromJson(json);

  Map<String, dynamic> toJson() => _$CashToJson(this);
}

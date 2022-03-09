import 'package:hive/hive.dart';

part 'cash_model.g.dart';

@HiveType(typeId: 12)
class Cash extends HiveObject {
    @HiveField(0)
  int? cashAmount;

  @HiveField(1)
  DateTime? cashDate;

  Cash({this.cashAmount, this.cashDate});
}

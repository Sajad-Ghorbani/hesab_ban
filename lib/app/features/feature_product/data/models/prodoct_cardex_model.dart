import 'package:hive/hive.dart';

class ProductCardex extends HiveObject{
  @HiveField(0)
  int? id;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  String? type;

  @HiveField(3)
  String? customer;

  @HiveField(4)
  double? incomingCount;

  @HiveField(5)
  double? outgoingCount;

  @HiveField(6)
  int? incomingPrice;

  @HiveField(7)
  int? outgoingPrice;

  @HiveField(8)
  double? totalCount;

  @HiveField(9)
  int? totalPrice;
}
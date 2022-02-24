import 'package:hive/hive.dart';
import 'bill_model.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 4)
class Customer extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? address;

  @HiveField(3)
  String? phoneNumber1;

  @HiveField(4)
  String? phoneNumber2;

  @HiveField(5)
  Bill? bill;

  Customer({
    this.id,
    this.name,
    this.address,
    this.phoneNumber1,
    this.phoneNumber2,
    this.bill,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phoneNumber1 = json['phone_number_1'];
    phoneNumber2 = json['phone_number_2'];
    bill = json['bill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone_number_1'] = phoneNumber1;
    data['phone_number_2'] = phoneNumber2;
    data['bill'] = bill;
    return data;
  }
}

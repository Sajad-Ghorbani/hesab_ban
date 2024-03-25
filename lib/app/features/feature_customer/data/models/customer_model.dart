import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable()
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
  int? initialAccountBalance;

  @HiveField(6)
  String? description;

  @HiveField(7)
  bool? isActive;

  Customer({
    this.id,
    this.name,
    this.address,
    this.phoneNumber1,
    this.phoneNumber2,
    this.initialAccountBalance,
    this.description,
    this.isActive,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
      address: address,
      phoneNumber1: phoneNumber1,
      phoneNumber2: phoneNumber2,
      initialAccountBalance: initialAccountBalance,
      description: description,
      isActive: isActive,
    );
  }

  factory Customer.fromEntity(CustomerEntity customerEntity) {
    return Customer(
      id: customerEntity.id,
      name: customerEntity.name,
      address: customerEntity.address,
      phoneNumber1: customerEntity.phoneNumber1,
      phoneNumber2: customerEntity.phoneNumber2,
      initialAccountBalance: customerEntity.initialAccountBalance,
      description: customerEntity.description,
      isActive: customerEntity.isActive,
    );
  }
}

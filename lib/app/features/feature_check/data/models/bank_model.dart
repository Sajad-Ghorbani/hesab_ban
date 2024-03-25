import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 13)
class Bank extends HiveObject{
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? imageAddress;

  Bank({this.name, this.imageAddress});

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  Map<String, dynamic> toJson() => _$BankToJson(this);

  BankEntity toEntity(){
    return BankEntity(
      name: name,
      imageAddress: imageAddress,
    );
  }

  factory Bank.fromEntity(BankEntity? bank){
    return Bank(
      name: bank?.name,
      imageAddress: bank?.imageAddress,
    );
  }
}
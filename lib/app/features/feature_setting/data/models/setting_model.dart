import 'package:hesab_ban/app/features/feature_setting/domain/entities/setting_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 14)
class Setting extends HiveObject {
  @HiveField(0)
  String? moneyUnit;

  @HiveField(1)
  bool? isMoneyUnitRial;

  @HiveField(2)
  int? notificationHours;

  @HiveField(3)
  int? notificationMinutes;

  @HiveField(4)
  bool? isThemeLight;

  @HiveField(5)
  bool? productCountCheck;

  @HiveField(6)
  String? costsLabel;

  @HiveField(7)
  String? stampLogo;

  @HiveField(8)
  String? signLogo;

  @HiveField(9)
  bool? showCustomerBalance;

  @HiveField(10)
  String? factorDescription;

  @HiveField(11)
  bool? showPaymentOrReceipt;

  @HiveField(12)
  bool? showFactorTax;

  @HiveField(13)
  bool? showFactorCosts;

  @HiveField(14)
  bool? showFactorOffer;

  @HiveField(15)
  String? barcodeUrl;

  @HiveField(16)
  bool? showPasswordScreen;

  Setting({
    this.moneyUnit,
    this.isMoneyUnitRial,
    this.notificationHours,
    this.notificationMinutes,
    this.isThemeLight,
    this.productCountCheck,
    this.costsLabel,
    this.stampLogo,
    this.signLogo,
    this.showCustomerBalance,
    this.factorDescription,
    this.showPaymentOrReceipt,
    this.showFactorTax,
    this.showFactorCosts,
    this.showFactorOffer,
    this.barcodeUrl,
    this.showPasswordScreen
  });

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  Map<String, dynamic> toJson() => _$SettingToJson(this);

  factory Setting.fromEntity(SettingEntity settingEntity) {
    return Setting(
      moneyUnit: settingEntity.moneyUnit,
      isMoneyUnitRial: settingEntity.isMoneyUnitRial,
      isThemeLight: settingEntity.isThemeLight,
      notificationHours: settingEntity.notificationHours,
      notificationMinutes: settingEntity.notificationMinutes,
      productCountCheck: settingEntity.productCountCheck,
      costsLabel: settingEntity.costsLabel,
      stampLogo: settingEntity.stampLogo,
      signLogo: settingEntity.signLogo,
      factorDescription: settingEntity.factorDescription,
      showCustomerBalance: settingEntity.showCustomerBalance,
      showPaymentOrReceipt: settingEntity.showPaymentOrReceipt,
      showFactorTax: settingEntity.showFactorTax,
      showFactorCosts: settingEntity.showFactorCosts,
      showFactorOffer: settingEntity.showFactorOffer,
      barcodeUrl: settingEntity.barcodeUrl,
      showPasswordScreen: settingEntity.showPasswordScreen,
    );
  }

  SettingEntity toEntity() {
    return SettingEntity(
      moneyUnit: moneyUnit,
      isMoneyUnitRial: isMoneyUnitRial,
      isThemeLight: isThemeLight,
      notificationHours: notificationHours,
      notificationMinutes: notificationMinutes,
      productCountCheck: productCountCheck,
      costsLabel: costsLabel,
      stampLogo: stampLogo,
      signLogo: signLogo,
      showCustomerBalance: showCustomerBalance,
      factorDescription: factorDescription,
      showPaymentOrReceipt: showPaymentOrReceipt,
      showFactorTax: showFactorTax,
      showFactorCosts: showFactorCosts,
      showFactorOffer: showFactorOffer,
      barcodeUrl: barcodeUrl,
      showPasswordScreen: showPasswordScreen,
    );
  }
}

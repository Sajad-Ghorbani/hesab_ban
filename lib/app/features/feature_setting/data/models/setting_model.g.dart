// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 14;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      moneyUnit: fields[0] as String?,
      isMoneyUnitRial: fields[1] as bool?,
      notificationHours: fields[2] as int?,
      notificationMinutes: fields[3] as int?,
      isThemeLight: fields[4] as bool?,
      productCountCheck: fields[5] as bool?,
      costsLabel: fields[6] as String?,
      stampLogo: fields[7] as String?,
      signLogo: fields[8] as String?,
      showCustomerBalance: fields[9] as bool?,
      factorDescription: fields[10] as String?,
      showPaymentOrReceipt: fields[11] as bool?,
      showFactorTax: fields[12] as bool?,
      showFactorCosts: fields[13] as bool?,
      showFactorOffer: fields[14] as bool?,
      barcodeUrl: fields[15] as String?,
      showPasswordScreen: fields[16] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.moneyUnit)
      ..writeByte(1)
      ..write(obj.isMoneyUnitRial)
      ..writeByte(2)
      ..write(obj.notificationHours)
      ..writeByte(3)
      ..write(obj.notificationMinutes)
      ..writeByte(4)
      ..write(obj.isThemeLight)
      ..writeByte(5)
      ..write(obj.productCountCheck)
      ..writeByte(6)
      ..write(obj.costsLabel)
      ..writeByte(7)
      ..write(obj.stampLogo)
      ..writeByte(8)
      ..write(obj.signLogo)
      ..writeByte(9)
      ..write(obj.showCustomerBalance)
      ..writeByte(10)
      ..write(obj.factorDescription)
      ..writeByte(11)
      ..write(obj.showPaymentOrReceipt)
      ..writeByte(12)
      ..write(obj.showFactorTax)
      ..writeByte(13)
      ..write(obj.showFactorCosts)
      ..writeByte(14)
      ..write(obj.showFactorOffer)
      ..writeByte(15)
      ..write(obj.barcodeUrl)
      ..writeByte(16)
      ..write(obj.showPasswordScreen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      moneyUnit: json['moneyUnit'] as String?,
      isMoneyUnitRial: json['isMoneyUnitRial'] as bool?,
      notificationHours: json['notificationHours'] as int?,
      notificationMinutes: json['notificationMinutes'] as int?,
      isThemeLight: json['isThemeLight'] as bool?,
      productCountCheck: json['productCountCheck'] as bool?,
      costsLabel: json['costsLabel'] as String?,
      stampLogo: json['stampLogo'] as String?,
      signLogo: json['signLogo'] as String?,
      showCustomerBalance: json['showCustomerBalance'] as bool?,
      factorDescription: json['factorDescription'] as String?,
      showPaymentOrReceipt: json['showPaymentOrReceipt'] as bool?,
      showFactorTax: json['showFactorTax'] as bool?,
      showFactorCosts: json['showFactorCosts'] as bool?,
      showFactorOffer: json['showFactorOffer'] as bool?,
      barcodeUrl: json['barcodeUrl'] as String?,
      showPasswordScreen: json['showPasswordScreen'] as bool?,
    );

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'moneyUnit': instance.moneyUnit,
      'isMoneyUnitRial': instance.isMoneyUnitRial,
      'notificationHours': instance.notificationHours,
      'notificationMinutes': instance.notificationMinutes,
      'isThemeLight': instance.isThemeLight,
      'productCountCheck': instance.productCountCheck,
      'costsLabel': instance.costsLabel,
      'stampLogo': instance.stampLogo,
      'signLogo': instance.signLogo,
      'showCustomerBalance': instance.showCustomerBalance,
      'factorDescription': instance.factorDescription,
      'showPaymentOrReceipt': instance.showPaymentOrReceipt,
      'showFactorTax': instance.showFactorTax,
      'showFactorCosts': instance.showFactorCosts,
      'showFactorOffer': instance.showFactorOffer,
      'barcodeUrl': instance.barcodeUrl,
      'showPasswordScreen': instance.showPasswordScreen,
    };

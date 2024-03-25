import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/setting_model.dart';
import 'package:hive/hive.dart';

class SettingDB {
  final _settingBox = Hive.box<Setting>(Constants.settingBox);

  Setting? get() {
    return _settingBox.get(0);
  }

  Future<void> save() async {
    if (_settingBox.isEmpty) {
      await _settingBox.put(
        0,
        Setting(
          isMoneyUnitRial: true,
          moneyUnit: 'ریال',
          isThemeLight: true,
          notificationHours: 8,
          notificationMinutes: 0,
          productCountCheck: true,
          showCustomerBalance: true,
          showPaymentOrReceipt: true,
          showFactorCosts: true,
          showFactorTax: true,
          showFactorOffer: true,
        ),
      );
    }
  }

  Future<void> update(Setting value) async {
    Setting? setting = _settingBox.get(0);
    if (setting != null) {
      setting.moneyUnit = value.moneyUnit ?? setting.moneyUnit;
      setting.isMoneyUnitRial =
          value.isMoneyUnitRial ?? setting.isMoneyUnitRial;
      setting.isThemeLight = value.isThemeLight ?? setting.isThemeLight;
      setting.notificationHours =
          value.notificationHours ?? setting.notificationHours;
      setting.notificationMinutes =
          value.notificationMinutes ?? setting.notificationMinutes;
      setting.productCountCheck =
          value.productCountCheck ?? setting.productCountCheck;
      setting.costsLabel = value.costsLabel ?? setting.costsLabel;
      setting.stampLogo = value.stampLogo ?? setting.stampLogo;
      setting.signLogo = value.signLogo ?? setting.signLogo;
      setting.showCustomerBalance =
          value.showCustomerBalance ?? setting.showCustomerBalance;
      setting.factorDescription =
          value.factorDescription ?? setting.factorDescription;
      setting.showPaymentOrReceipt =
          value.showPaymentOrReceipt ?? setting.showPaymentOrReceipt;
      setting.showFactorTax =
          value.showFactorTax ?? setting.showFactorTax;
      setting.showFactorCosts =
          value.showFactorCosts ?? setting.showFactorCosts;
      setting.showFactorOffer =
          value.showFactorOffer ?? setting.showFactorOffer;
      setting.barcodeUrl =
          value.barcodeUrl ?? setting.barcodeUrl;
      setting.showPasswordScreen =
          value.showPasswordScreen ?? setting.showPasswordScreen;
      await setting.save();
    }
  }

  Future<void> deleteFromSetting(String value) async {
    Setting? setting = _settingBox.get(0);
    if (setting != null) {
      if (value == 'stampLogo') {
        setting.stampLogo = null;
      } //
      else if (value == 'signLogo') {
        setting.signLogo = null;
      } //
      else if (value == 'costLabel') {
        setting.costsLabel = null;
      } //
      else if (value == 'factorDescription') {
        setting.factorDescription = null;
      }//
      else if (value == 'barcodeUrl') {
        setting.barcodeUrl = null;
      }
      await setting.save();
    }
  }
}

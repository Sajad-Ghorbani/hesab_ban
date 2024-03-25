class SettingEntity {
  String? moneyUnit;

  bool? isMoneyUnitRial;

  int? notificationHours;

  int? notificationMinutes;

  bool? isThemeLight;

  bool? productCountCheck;

  String? costsLabel;

  String? stampLogo;

  String? signLogo;

  bool? showCustomerBalance;

  String? factorDescription;

  bool? showPaymentOrReceipt;

  bool? showFactorTax;

  bool? showFactorCosts;

  bool? showFactorOffer;

  String? barcodeUrl;

  bool? showPasswordScreen;

  SettingEntity({
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
    this.showPasswordScreen,
  });
}

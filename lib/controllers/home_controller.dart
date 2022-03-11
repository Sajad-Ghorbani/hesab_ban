import 'dart:io';

import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../static_methods.dart';

class HomeController extends GetxController {
  late PersistentTabController pageController;
  late ScrollController checkScreenScrollController;
  late ScrollController customerScreenScrollController;
  late Box customerBox;
  late Box<Check> homeChecksBox;
  var boxSetting = Hive.lazyBox(settingBox);

  RxBool showCheckFab = true.obs;
  RxBool showCustomersFab = true.obs;

  RxBool showBuyHelp = true.obs;
  RxBool showSellHelp = true.obs;
  RxBool showOneSellHelp = true.obs;
  RxBool moneyUnitChange = true.obs;
  RxString moneyUnit = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PersistentTabController();
    checkScreenScrollController = ScrollController();
    customerScreenScrollController = ScrollController();
    customerBox = Hive.box<Customer>(customersBox);
    homeChecksBox = Hive.box<Check>(checksBox);
    getShowHelp('sellFactorHelp', showSellHelp);
    getShowHelp('OneSellFactorHelp', showOneSellHelp);
    getShowHelp('buyFactorHelp', showBuyHelp);
    getMoneyUnit();
  }

  changeShowHelp(String key, RxBool value) async {
    value.value = !value.value;
    await boxSetting.put(key, value.value);
  }

  getShowHelp(String key, RxBool showFactor) async {
    showFactor.value = await boxSetting.get(key);
  }

  void changeMoneyUnit(bool value) {
    moneyUnitChange.value = value;
    moneyUnit.value = value ? 'ریال' : 'تومان';
    boxSetting.put('moneyUnitRial', value);
    boxSetting.put('moneyUnit', moneyUnit.value);
  }

  void getMoneyUnit() async {
    moneyUnitChange.value = await boxSetting.get('moneyUnitRial');
    moneyUnit.value = await boxSetting.get('moneyUnit');
  }

  void openWhatsApp() async {
    var whatsapp = "+989351679934";
    var whatsappUrlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=سلام. من برای برنامه حساب بان نظری داشتم.";
    var whatsappUrlIOS = "https://wa.me/$whatsapp?text=${Uri.parse("سلام. من برای برنامه حساب بان نظری داشتم.")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatsappUrlIOS)) {
        await launch(whatsappUrlIOS, forceSafariVC: false);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    } else {
      // android , web
      if (await canLaunch(whatsappUrlAndroid)) {
        await launch(whatsappUrlAndroid);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    }
  }
}

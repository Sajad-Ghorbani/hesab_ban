import 'package:flutter/material.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/category_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/customer_model.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  double fontSize = 2;
  double containerSize = 1.5;
  double textOpacity = 0.0;
  double containerOpacity = 0.0;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async => openAppBox());
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation = Tween<double>(begin: 50, end: 30).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        textOpacity = 1.0;
        update();
      });

    animationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      fontSize = 1.06;
      update();
    });

    Future.delayed(const Duration(seconds: 2), () {
      containerSize = 2;
      containerOpacity = 1;
      update();
    });

    Future.delayed(const Duration(seconds: 4), () {
      Get.offNamed(Routes.mainScreen);
    });
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }

  openAppBox() async {
    await Hive.openBox<Product>(allProductBox);
    await Hive.openBox<Customer>(customersBox);
    await Hive.openBox<Check>(checksBox);
    await Hive.openLazyBox<Factor>(factorBox);
    await Hive.openLazyBox<Bill>(billsBox);
    var boxSetting = await Hive.openLazyBox(settingBox);
    if (boxSetting.isEmpty) {
      boxSetting.put('moneyUnitRial', true);
      boxSetting.put('moneyUnit', 'ریال');
      boxSetting.put('storeName', '');
      boxSetting.put('storeAddress', '');
      boxSetting.put('storeLogo', '-1');
      boxSetting.put('notificationHours', 8);
      boxSetting.put('notificationMinutes', 0);
    }
    var box = await Hive.openBox<Category>(productCategoryBox);
    if (box.isEmpty) {
      await box.add(Category(id: 0, name: defaultCategoryName));
    }
  }
}

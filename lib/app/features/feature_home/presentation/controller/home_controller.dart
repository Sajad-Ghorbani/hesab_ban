import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/screens/select_factor_screen.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/screens/home_screen.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/screens/all_product_screen.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/notification_service.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController {
  bool exitApp = false;
  int currentIndex = 0;
  bool reversScreensSlide = false;

  List screens = const [
    HomeScreen(),
    AllProductScreen(),
    SelectFactorScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    NotificationService().receiveNotification();
  }

  @override
  onClose() {
    super.onClose();
    Hive.close();
  }

  void changeIndex(int index) {
    reversScreensSlide = index > currentIndex;
    currentIndex = index;
    update();
  }

  Future<bool> willPop() async {
    if (currentIndex != 0) {
      currentIndex = 0;
      update();
      return false;
    }
    if (!exitApp) {
      Get.snackbar('خروج', 'برای خروج یکبار دیگر دکمه بازگشت را بزنید.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10));
      exitApp = true;
      Future.delayed(
        const Duration(seconds: 3),
        () {
          exitApp = false;
        },
      );
      return false;
    } //
    else {
      return true;
    }
  }
}

import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeController extends GetxController {
  late PersistentTabController pageController;
  late ScrollController checkScreenScrollController;
  late ScrollController customerScreenScrollController;
  late Box customerBox;
  late Box<Check> homeChecksBox;

  RxBool showCheckFab = true.obs;
  RxBool showCustomersFab = true.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PersistentTabController(initialIndex: 2);
    checkScreenScrollController = ScrollController();
    customerScreenScrollController = ScrollController();
    customerBox = Hive.box<Customer>(customersBox);
    homeChecksBox = Hive.box<Check>(checksBox);
  }
}

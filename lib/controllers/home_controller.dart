import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/customer_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeController extends GetxController {
  late PersistentTabController pageController;
  late Box customerBox;

  @override
  void onInit() {
    super.onInit();
    pageController = PersistentTabController(initialIndex: 2);
    customerBox = Hive.box<Customer>(customersBox);
  }
}

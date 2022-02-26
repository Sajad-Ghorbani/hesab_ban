import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainController extends GetxController {
  late PersistentTabController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PersistentTabController(initialIndex: 2);
  }
}

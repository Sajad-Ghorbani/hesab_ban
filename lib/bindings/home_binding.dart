import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/print_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<PrintController>(PrintController());
  }
}

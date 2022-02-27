import 'package:get/get.dart';

import '../controllers/customer_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/product_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<ProductController>(ProductController());
    Get.put<CustomerController>(CustomerController());
  }
}

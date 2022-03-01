import 'package:hesab_ban/controllers/customer_controller.dart';
import 'package:get/get.dart';

class CustomerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerController>(() => CustomerController());
  }
}

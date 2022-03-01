import 'package:accounting_app/controllers/check_controller.dart';
import 'package:get/get.dart';

class CheckBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CheckController>(() => CheckController());
  }
}
import 'package:get/get.dart';
import 'package:hesab_ban/controllers/factor_controller.dart';

class FactorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FactorController>(() => FactorController());
  }
}

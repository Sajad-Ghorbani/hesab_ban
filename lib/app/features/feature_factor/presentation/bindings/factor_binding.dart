import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/controller/factor_controller.dart';

class FactorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FactorController>(() => FactorController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
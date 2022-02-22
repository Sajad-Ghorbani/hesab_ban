import 'package:accounting_app/controllers/splash_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}

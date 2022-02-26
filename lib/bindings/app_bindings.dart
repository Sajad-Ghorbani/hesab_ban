import 'package:accounting_app/controllers/main_controller.dart';
import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/controllers/splash_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
    Get.put<MainController>(MainController());
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
  }
}

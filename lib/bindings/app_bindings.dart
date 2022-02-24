import 'package:accounting_app/controllers/home_controller.dart';
import 'package:accounting_app/controllers/product_controller.dart';
import 'package:accounting_app/controllers/splash_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
  }
}

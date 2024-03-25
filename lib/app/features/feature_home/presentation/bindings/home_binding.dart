import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/controller/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

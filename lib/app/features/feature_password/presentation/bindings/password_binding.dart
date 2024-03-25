import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/controller/password_controller.dart';

class PasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PasswordController>(PasswordController(Get.find(),Get.find()));
  }
}

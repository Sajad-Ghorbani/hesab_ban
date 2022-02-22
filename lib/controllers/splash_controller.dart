import 'package:accounting_app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 3),(){
      Get.offNamed(Routes.homeScreen);
    });
  }
}
import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await openAppBox();
    });
  }

  openAppBox() async {
    await Hive.openBox<Product>(allProductBox);
    await Hive.openBox<String>(productFolderNameBox);
    Get.offNamed(Routes.mainScreen);
  }
}

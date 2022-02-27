import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/category_model.dart';
import 'package:accounting_app/models/check_model.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/customer_model.dart';

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
    await Hive.openBox<Customer>(customersBox);
    await Hive.openBox<Check>(checksBox);
    var box = await Hive.openBox<Category>(productCategoryBox);
    if (box.isEmpty) {
      await box.add(Category(id: 0, name: defaultCategoryName));
    }
    Get.offNamed(Routes.mainScreen);
  }
}

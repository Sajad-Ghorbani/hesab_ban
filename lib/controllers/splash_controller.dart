import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/category_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/customer_model.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      await openAppBox();
    });
  }

  openAppBox() async {
    await Hive.openBox<Product>(allProductBox);
    await Hive.openBox<Customer>(customersBox);
    await Hive.openBox<Check>(checksBox);
    await Hive.openLazyBox<Factor>(factorBox);
    await Hive.openLazyBox<Bill>(billsBox);
    var boxSetting = await Hive.openLazyBox(settingBox);
    if(boxSetting.isEmpty){
      boxSetting.put('moneyUnitRial',true);
      boxSetting.put('moneyUnit','ریال');
      boxSetting.put('storeName','');
      boxSetting.put('storeAddress','');
      boxSetting.put('storeLogo','-1');
      boxSetting.put('notificationHours',8);
      boxSetting.put('notificationMinutes',0);
    }
    var box = await Hive.openBox<Category>(productCategoryBox);
    if (box.isEmpty) {
      await box.add(Category(id: 0, name: defaultCategoryName));
    }
    Get.offNamed(Routes.mainScreen);
  }
}

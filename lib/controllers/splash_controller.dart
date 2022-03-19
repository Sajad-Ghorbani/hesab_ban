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
    // TODO: implement onInit
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
      boxSetting.put('sellFactorHelp', true);
      boxSetting.put('OneSellFactorHelp', true);
      boxSetting.put('buyFactorHelp', true);
      boxSetting.put('returnOfBuyFactorHelp', true);
      boxSetting.put('returnOfSellFactorHelp', true);
      boxSetting.put('moneyUnitRial',true);
      boxSetting.put('moneyUnit','ریال');
    }
    var box = await Hive.openBox<Category>(productCategoryBox);
    if (box.isEmpty) {
      await box.add(Category(id: 0, name: defaultCategoryName));
    }
    Get.offNamed(Routes.mainScreen);
  }
}

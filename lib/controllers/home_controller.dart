import 'dart:io';

import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/category_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/ui/screens/product_folder_screen.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../static_methods.dart';
import '../ui/theme/app_colors.dart';

class HomeController extends GetxController {
  TextEditingController categoryNameController = TextEditingController();

  late PersistentTabController pageController;
  late ScrollController checkScreenScrollController;
  late ScrollController customerScreenScrollController;
  late ScrollController productScreenScrollController;

  var customerBox = Hive.box<Customer>(customersBox);
  var homeChecksBox = Hive.box<Check>(checksBox);
  var boxSetting = Hive.lazyBox(settingBox);
  var productBox = Hive.box<Product>(allProductBox);
  var categoryBox = Hive.box<Category>(productCategoryBox);

  RxBool showCheckFab = true.obs;
  RxBool showCustomersFab = true.obs;
  RxBool showProductsFab = true.obs;
  RxBool showCategoryProductsFab = true.obs;

  RxBool showBuyHelp = true.obs;
  RxBool showSellHelp = true.obs;
  RxBool showOneSellHelp = true.obs;
  RxBool moneyUnitChange = true.obs;
  RxString moneyUnit = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PersistentTabController();
    checkScreenScrollController = ScrollController();
    customerScreenScrollController = ScrollController();
    productScreenScrollController = ScrollController();
    getShowHelp('sellFactorHelp', showSellHelp);
    getShowHelp('OneSellFactorHelp', showOneSellHelp);
    getShowHelp('buyFactorHelp', showBuyHelp);
    getMoneyUnit();
  }

  @override
  onClose(){
    super.onClose();
    pageController.dispose();
    checkScreenScrollController.dispose();
    customerScreenScrollController.dispose();
    productScreenScrollController.dispose();
    Hive.close();
  }

  changeShowHelp(String key, RxBool value) async {
    value.value = !value.value;
    await boxSetting.put(key, value.value);
  }

  getShowHelp(String key, RxBool showFactor) async {
    showFactor.value = await boxSetting.get(key);
  }

  void changeMoneyUnit(bool value) {
    moneyUnitChange.value = value;
    moneyUnit.value = value ? 'ریال' : 'تومان';
    boxSetting.put('moneyUnitRial', value);
    boxSetting.put('moneyUnit', moneyUnit.value);
  }

  void getMoneyUnit() async {
    moneyUnitChange.value = await boxSetting.get('moneyUnitRial');
    moneyUnit.value = await boxSetting.get('moneyUnit');
  }

  void openWhatsApp() async {
    var whatsapp = "+989351679934";
    var whatsappUrlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=سلام. من برای برنامه حساب بان نظری داشتم.";
    var whatsappUrlIOS = "https://wa.me/$whatsapp?text=${Uri.parse("سلام. من برای برنامه حساب بان نظری داشتم.")}";
    if (Platform.isIOS) {
      if (await canLaunch(whatsappUrlIOS)) {
        await launch(whatsappUrlIOS, forceSafariVC: false);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    } else {
      if (await canLaunch(whatsappUrlAndroid)) {
        await launch(whatsappUrlAndroid);
      } else {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: 'برنامه واتساپ بر روی گوشی شما نصب نمی باشد.',
        );
      }
    }
  }

  void navigateToCategory(
      context,
      String categoryName,
      bool selectProduct,
      bool fromSearch,
      ) async {
    pushNewScreen(
      context,
      screen: ProductFolderScreen(
        categoryName: categoryName,
        selectProduct: selectProduct,
        fromSearch: fromSearch,
      ),
    );
  }

  void addNewCategory() async {
    String categoryName = categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      Future.delayed(
        const Duration(milliseconds: 300),
            () {
          StaticMethods.showSnackBar(
              title: 'خطا', description: 'لطفا نام را وارد کنید.');
        },
      );
    } //
    else {
      if (categoryBox.isEmpty) {
        await categoryBox.add(Category(id: 0, name: categoryName));
      } //
      else {
        Category newCategory = Category(name: categoryName);
        int index = await categoryBox.add(newCategory);
        newCategory.id = index;
        newCategory.save();
      }
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'دسته جدید با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
      categoryNameController.clear();
    }
  }

  void updateCategory(Category category) async {
    String categoryName = categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        StaticMethods.showSnackBar(
            title: 'خطا', description: 'لطفا نام را وارد کنید.');
      });
    } //
    else {
      category.name = categoryName;
      category.save();
      categoryNameController.clear();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'دسته $categoryName با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
    }
  }

  void deleteCategory(Category category) async {
    for (var item in productBox.values) {
      if (item.category!.name == category.name) {
        await item.delete();
      }
    }
    await category.delete();
  }
}

import 'dart:io';

import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/cash_model.dart';
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
  TextEditingController cashPaymentController = TextEditingController();

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
  RxBool showReturnOfSellHelp = true.obs;
  RxBool showReturnOfBuyHelp = true.obs;
  RxBool moneyUnitChange = true.obs;
  RxString moneyUnit = ''.obs;

  Customer? cashCustomer;
  String typeOfCash = '';

  bool exitApp = false;

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
    getShowHelp('returnOfBuyFactorHelp', showBuyHelp);
    getShowHelp('returnOfSellFactorHelp', showBuyHelp);
    getMoneyUnit();
  }

  @override
  onClose() {
    super.onClose();
    pageController.dispose();
    checkScreenScrollController.dispose();
    customerScreenScrollController.dispose();
    productScreenScrollController.dispose();
    categoryNameController.dispose();
    cashPaymentController.dispose();
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
    var whatsappUrlAndroid = "whatsapp://send?phone=" +
        whatsapp +
        "&text=سلام. من برای برنامه حساب بان نظری داشتم.";
    var whatsappUrlIOS =
        "https://wa.me/$whatsapp?text=${Uri.parse("سلام. من برای برنامه حساب بان نظری داشتم.")}";
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
      Get.back();
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
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          StaticMethods.showSnackBar(
              title: 'خطا', description: 'لطفا نام را وارد کنید.');
        },
      );
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

  void inputCash() async {
    await StaticMethods.selectDetails(
      title: 'پرداخت وجه نقد از طرف',
      onMeTap: () {
        typeOfCash = 'me';
        Get.back();
      },
      onCustomerTap: () {
        typeOfCash = 'customer';
        Get.back();
      },
    );
    await StaticMethods.selectCustomer(
      title: 'مشتری را انتخاب کنید',
      dropDownList: setCustomerList(),
      onSelectCustomer: (int? value) {
        for (var item in customerBox.values) {
          if (item.id == value) {
            cashCustomer = item;
          }
        }
        Get.back();
      },
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await StaticMethods.showCashPaymentDialog(
          cashPaymentController,
          () {
            saveCashToCustomerBill();
            Get.back();
            cashPaymentController.clear();
          },
        );
      },
    );
  }

  List<DropdownMenuItem<int>> setCustomerList() {
    List<DropdownMenuItem<int>> list = [];
    for (var item in customerBox.values) {
      list.add(
        DropdownMenuItem(
          child: Text(item.name!),
          value: item.id,
        ),
      );
    }
    return list;
  }

  void saveCashToCustomerBill() async {
    if (cashPaymentController.text.trim().isNotEmpty) {
      int cashAmount = StaticMethods.removeSeparatorFromNumber(cashPaymentController);
      var billBox = Hive.lazyBox<Bill>(billsBox);
      Cash cash = Cash(
        cashAmount: typeOfCash == 'me' ? -cashAmount : cashAmount,
        cashDate: DateTime.now(),
      );
      int key = billBox.keys.firstWhere((key) => key == cashCustomer!.id);
      Bill? newBill = await billBox.get(key);
      newBill!.cash!.add(cash);
      await newBill.save();
      StaticMethods.showSnackBar(
        title: 'تبریک',
        description: 'پرداخت وجه نقد با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
    }
  }

  bool willPop() {
    if (!exitApp) {
      Get.snackbar('خروج', 'برای خروج یکبار دیگر دکمه بازگشت را بزنید.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10));
      exitApp = true;
      Future.delayed(
        const Duration(seconds: 3),
        () {
          exitApp = false;
        },
      );
      return false;
    } //
    else {
      return true;
    }
  }
}

import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:hesab_ban/data/models/bank_model.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/theme/app_text_theme.dart';
import 'package:hesab_ban/ui/theme/constants_app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/ui/widgets/confirm_button.dart';
import 'package:hive/hive.dart';

import 'controllers/home_controller.dart';
import '/data/models/bill_model.dart';
import '/data/models/cash_model.dart';
import '/data/models/category_model.dart';
import '/data/models/check_model.dart';
import '/data/models/customer_model.dart';
import '/data/models/factor_model.dart';
import '/data/models/factor_row.dart';
import '/data/models/product_model.dart';
import '/data/models/user_model.dart';

class StaticMethods {
  static void hiveAdapters() {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UnitAdapter());
    Hive.registerAdapter(FactorAdapter());
    Hive.registerAdapter(FactorRowAdapter());
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(CheckAdapter());
    Hive.registerAdapter(BillAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TypeOfCheckAdapter());
    Hive.registerAdapter(TypeOfFactorAdapter());
    Hive.registerAdapter(CashAdapter());
    Hive.registerAdapter(BankAdapter());
  }

  static removeSeparatorFromNumber(TextEditingController controller,
      {bool toDouble = false}) {
    String text = controller.text.trim().replaceAll(',', '');
    if (toDouble) {
      double number = double.parse(text);
      return number;
    } //
    else {
      int number = int.parse(text);
      return number;
    }
  }

  static double roundDouble(double value) {
    return ((value * 100).round().toDouble() / 100);
  }

  static void showSnackBar({
    required String title,
    required String description,
    Color? color,
    Duration? duration,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: const TextStyle(fontWeight: kWeightBold, color: Colors.white),
      ),
      messageText: Text(
        description,
        style: const TextStyle(height: 1.5, color: Colors.white),
      ),
      backgroundColor: color == null
          ? kRedColor.withOpacity(Get.isDarkMode ? 0.3 : 0.8)
          : color.withOpacity(Get.isDarkMode ? 0.3 : 0.8),
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void inputProductCount({
    required Product product,
    required VoidCallback onConfirm,
    required TextEditingController productCountController,
    required TextEditingController productPriceController,
  }) {
    Get.defaultDialog(
      title: 'نام محصول: ${product.name!}',
      onWillPop: () async {
        productPriceController.clear();
        productCountController.clear();
        return true;
      },
      confirm: ConfirmButton(onTap: onConfirm),
      content: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('تعداد'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 40,
                width: 80,
                child: TextField(
                  controller: productCountController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('قیمت'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 40,
                width: 80,
                child: TextField(
                  controller: productPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                Get.find<HomeController>().moneyUnit.value,
                style: kRialTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> showCashPaymentDialog(
    TextEditingController cashPaymentController,
    VoidCallback onConfirmTap,
  ) async {
    await Get.defaultDialog(
      title: 'ورود مبلغ',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('مبلغ'),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 120,
            height: 30,
            child: TextField(
              controller: cashPaymentController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                CurrencyTextInputFormatter(
                  decimalDigits: 0,
                  symbol: '',
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            Get.find<HomeController>().moneyUnit.value,
            style: kRialTextStyle,
          ),
        ],
      ),
      confirm: ConfirmButton(onTap: onConfirmTap),
    );
  }

  static void showFolderDialog(
      {required String title,
      required TextEditingController controller,
      required VoidCallback onTap}) {
    Get.defaultDialog(
      title: title,
      content: Row(
        children: [
          const Text('نام پوشه'),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: TextField(
              controller: controller,
            ),
          ),
        ],
      ),
      confirm: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kGreenColor,
                kLightGreenColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 35,
          width: 80,
          alignment: Alignment.center,
          child: const Text('تایید'),
        ),
      ),
    );
  }

  static Future<void> productBottomSheet(
    BuildContext context, {
    required String name,
    required VoidCallback onEditTap,
    VoidCallback? onDeleteTap,
    bool showDelete = true,
  }) async {
    await Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                width: Get.width - 80,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: kOrangeColor,
                        ),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: onEditTap,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('ویرایش'),
                      ),
                    ),
                    Visibility(
                      visible: showDelete,
                      child: Column(
                        children: [
                          const Divider(),
                          GestureDetector(
                            onTap: onDeleteTap,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('حذف'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  static deleteDialog(
      {required String content, required VoidCallback onConfirm}) {
    Get.defaultDialog(
      title: 'احتیاط',
      content: Text(
        content,
        style: const TextStyle(
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      confirm: InkWell(
        onTap: onConfirm,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kGreenColor,
                kLightGreenColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 35,
          width: 80,
          alignment: Alignment.center,
          child: const Text('تایید'),
        ),
      ),
      cancel: InkWell(
        onTap: () {
          Get.back();
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kRedColor,
                Colors.redAccent,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 35,
          width: 80,
          alignment: Alignment.center,
          child: const Text('لغو'),
        ),
      ),
    );
  }

  static Future<void> selectDetails({
    required String title,
    required VoidCallback onMeTap,
    required VoidCallback onCustomerTap,
  }) async {
    await Get.bottomSheet(
      Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  width: Get.width - 80,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: onMeTap,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('خودم'),
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: onCustomerTap,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('مشتری'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }),
      isDismissible: false,
    );
  }

  static Future<void> selectCustomer({
    required String title,
    required List<DropdownMenuItem<int>> dropDownList,
    required ValueChanged<int?> onSelectCustomer,
  }) async {
    await Get.bottomSheet(
      Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  width: Get.width - 80,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: Get.width - 120,
                        child: DropdownButtonFormField<int>(
                          items: dropDownList,
                          elevation: 8,
                          onChanged: onSelectCustomer,
                          value: 0,
                          decoration: kCustomInputDecoration,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }),
      isDismissible: false,
    );
  }

  static String setTypeFactorString(TypeOfFactor typeOfFactor) {
    switch (typeOfFactor) {
      case TypeOfFactor.buy:
        return 'فاکتور خرید';
      case TypeOfFactor.sale:
        return 'فاکتور فروش';
      case TypeOfFactor.oneSale:
        return 'فاکتور خرده فروشی';
      case TypeOfFactor.returnOfBuy:
        return 'فاکتور برگشت از خرید';
      case TypeOfFactor.returnOfSale:
        return 'فاکتور برگشت از فروش';
      default:
        return '';
    }
  }
}

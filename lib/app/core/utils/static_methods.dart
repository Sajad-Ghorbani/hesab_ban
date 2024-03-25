import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/app_text_theme.dart';
import 'package:hesab_ban/app/config/theme/app_theme.dart';
import 'package:hesab_ban/app/config/theme/constants_app_styles.dart';
import 'package:hesab_ban/app/core/widgets/confirm_button.dart';
import 'package:hesab_ban/app/core/widgets/loading.dart';
import 'package:hesab_ban/app/features/feature_bill/data/models/bill_model.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/bank_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_row.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/controller/factor_controller.dart';
import 'package:hesab_ban/app/features/feature_print/presentation/controller/print_controller.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/category_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/product_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/unit_of_product.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/setting_model.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/user_model.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:printing/printing.dart';

class StaticMethods {
  final GetSettingUseCase getSettingUseCase;

  StaticMethods(this.getSettingUseCase);

  static void hiveAdapters() {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UnitAdapter());
    Hive.registerAdapter(UnitOfProductAdapter());
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
    Hive.registerAdapter(SettingAdapter());
  }

  ThemeData getThemeMode() {
    bool? isLightTheme;
    var response = getSettingUseCase();
    if (response.data == null) {
      isLightTheme = true;
    } //
    else {
      isLightTheme = response.data!.isThemeLight!;
    }
    return isLightTheme ? AppThemeData.lightTheme : AppThemeData.darkTheme;
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
    String? description,
    Widget? content,
    Color? color,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: const TextStyle(fontWeight: kWeightBold, color: Colors.white),
      ),
      messageText: content ??
          Text(
            description!,
            style: const TextStyle(height: 1.5, color: Colors.white),
          ),
      backgroundColor: color == null
          ? kRedColor.withOpacity(Get.isDarkMode ? 0.3 : 0.8)
          : color.withOpacity(Get.isDarkMode ? 0.3 : 0.8),
      duration: duration,
    );
  }

  static void inputProductCount({
    required ProductEntity product,
    required VoidCallback onConfirm,
    required TextEditingController productCountController,
    required TextEditingController productPriceOfSaleController,
    TextEditingController? productPriceOfBuyController,
    TextEditingController? productPriceOfOneSaleController,
    required bool isBuy,
  }) {
    Get.defaultDialog(
      title: 'نام محصول: ${product.name!}',
      onWillPop: () async {
        productCountController.clear();
        productPriceOfSaleController.clear();
        productPriceOfBuyController?.clear();
        productPriceOfOneSaleController?.clear();
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
              const SizedBox(width: 10),
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
          if (isBuy)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('قیمت خرید'),
                const SizedBox(width: 10),
                SizedBox(
                  height: 40,
                  width: 80,
                  child: TextField(
                    controller: productPriceOfBuyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        decimalDigits: 0,
                        symbol: '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  Get.find<SettingController>().moneyUnit,
                  style: kRialTextStyle,
                ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isBuy ? 'قیمت فروش' : 'قیمت'),
              const SizedBox(width: 10),
              SizedBox(
                height: 40,
                width: 80,
                child: TextField(
                  controller: productPriceOfSaleController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Text(
                Get.find<SettingController>().moneyUnit,
                style: kRialTextStyle,
              ),
            ],
          ),
          if (isBuy)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const FittedBox(child: Text('قیمت خرده فروشی')),
                const SizedBox(width: 10),
                SizedBox(
                  height: 40,
                  width: 80,
                  child: TextField(
                    controller: productPriceOfOneSaleController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        decimalDigits: 0,
                        symbol: '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  Get.find<SettingController>().moneyUnit,
                  style: kRialTextStyle,
                ),
              ],
            ),
        ],
      ),
    );
  }

  static void showSingleRowDialog({
    required String title,
    required String rowTitle,
    required TextEditingController controller,
    required VoidCallback onTap,
    TextInputType? keyboardType,
  }) {
    Get.defaultDialog(
      title: title,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(rowTitle),
          const SizedBox(width: 20),
          SizedBox(
            height: 40,
            width: 120,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onTap: () {
                textFieldOnTap(controller);
              },
            ),
          ),
        ],
      ),
      confirm: ConfirmButton(onTap: onTap),
    );
  }

  static Future<void> customBottomSheet(
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ویرایش',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'حذف',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
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

  static deleteDialog({
    String? content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
    Widget? contentWidget,
  }) {
    Get.defaultDialog(
      title: 'احتیاط',
      barrierDismissible: barrierDismissible,
      content: contentWidget ??
          Text(
            content!,
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
          child: Text(confirmText ?? 'تایید'),
        ),
      ),
      cancel: InkWell(
        onTap: () {
          Get.back();
          if (onCancel != null) {
            onCancel();
          }
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
          child: Text(cancelText ?? 'لغو'),
        ),
      ),
    );
  }

  static Future<Jalali?> getDate(BuildContext context) async {
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali.now() - 365,
      lastDate: Jalali(1450, 9),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  Get.isDarkMode ? Colors.white : null, // button text color
            ),
          ),
        ),
        child: child!,
      ),
    );
    return pickedDate?.add(
        hours: DateTime.now().hour, minutes: DateTime.now().minute);
  }

  static String setTypeFactorString(String typeOfFactor) {
    switch (typeOfFactor) {
      case 'buy':
        return 'فاکتور خرید';
      case 'sale':
        return 'فاکتور فروش';
      case 'oneSale':
        return 'فاکتور خرده فروشی';
      case 'returnOfBuy':
        return 'فاکتور برگشت از خرید';
      case 'returnOfSale':
        return 'فاکتور برگشت از فروش';
      default:
        return '';
    }
  }

  static void textFieldOnTap(TextEditingController controller) {
    if (controller.selection ==
        TextSelection.fromPosition(
            TextPosition(offset: controller.text.length - 1))) {
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  static void showFactor(BuildContext context, FactorEntity factor,
      [bool showDelete = false]) async {
    showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<PrintController>(
            init: PrintController(),
            builder: (printController) {
              return InteractiveViewer(
                maxScale: 2,
                child: PdfPreview(
                  build: (format) {
                    if (factor.customer?.id != null) {
                      Get.find<BillController>()
                          .getBillById(factor.customer!.id!);
                    }
                    return printController.generateFactor(
                      factor,
                      Get.find<BillController>().billEntity?.cashPayment,
                    );
                  },
                  canDebug: false,
                  canChangeOrientation: false,
                  allowSharing: false,
                  allowPrinting: false,
                  canChangePageFormat: false,
                  loadingWidget: const Loading(
                    showLoading: true,
                  ),
                  scrollViewDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Iconsax.arrow_right_3),
                      color: Colors.white,
                      splashRadius: 30,
                    ),
                    IconButton(
                        onPressed: () {
                          if (factor.typeOfFactor?.name == 'oneSale') {
                            Get.back();
                            Get.toNamed(
                              Routes.oneSaleFactorScreen,
                              arguments: factor,
                              parameters: {'type': factor.typeOfFactor!.name},
                            );
                          } //
                          else {
                            Get.back();
                            Get.toNamed(
                              Routes.factorScreen,
                              arguments: factor,
                              parameters: {'type': factor.typeOfFactor!.name},
                            );
                          }
                        },
                        icon: const Icon(Iconsax.edit)),
                    IconButton(
                        onPressed: () async {
                          final pdfFile = await Get.find<BillController>()
                              .saveFactor(factor);
                          if (pdfFile != null) {
                            printController.shareFile(pdfFile);
                          }
                        },
                        icon: const Icon(Iconsax.share)),
                    IconButton(
                        onPressed: () {
                          Printing.layoutPdf(
                            onLayout: (format) {
                              return printController.generateFactor(
                                factor,
                                Get.find<BillController>()
                                    .billEntity
                                    ?.cashPayment,
                              );
                            },
                          );
                        },
                        icon: const Icon(Iconsax.printer)),
                    if (showDelete)
                      IconButton(
                          onPressed: () {
                            Get.back();
                            StaticMethods.deleteDialog(
                              content:
                                  'در صورت حدف کامل فاکتور، به تعداد کالاهای موجود در فاکتور '
                                  '${factor.typeOfFactor == TypeOfFactor.buy || factor.typeOfFactor == TypeOfFactor.returnOfSale ? 'از' : 'به'}'
                                  ' موجودی آنها '
                                  '${factor.typeOfFactor == TypeOfFactor.buy || factor.typeOfFactor == TypeOfFactor.returnOfSale ? 'کسر' : 'اضافه'}'
                                  '${factor.typeOfFactor != TypeOfFactor.oneSale ? ' و از '
                                      '${factor.typeOfFactor == TypeOfFactor.buy || factor.typeOfFactor == TypeOfFactor.returnOfSale ? 'بستانکاری فروشنده' : 'بدهکاری مشتری'}' : ''}'
                                  '${factor.typeOfFactor == TypeOfFactor.oneSale ? '' : ' کم'}'
                                  ' خواهد شد.\n آیا مطمئن هستید؟',
                              onConfirm: () {
                                Get.find<FactorController>()
                                    .deleteFactor(factor);
                              },
                            );
                          },
                          icon: const Icon(Iconsax.trash)),
                  ],
                ),
              );
            });
      },
    );
  }
}

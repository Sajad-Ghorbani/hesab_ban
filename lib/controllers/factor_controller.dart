import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/cash_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/models/factor_row.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hive/hive.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../models/product_model.dart';
import '../routes/app_pages.dart';
import '../ui/theme/app_colors.dart';

class FactorController extends GetxController {
  TypeOfFactor typeOfFactor = Get.arguments;
  RxList<FactorRow> listFactorRow = <FactorRow>[].obs;
  RxString factorSum = '-1'.obs;
  RxInt cashAmount = 0.obs;
  RxInt checkAmount = 0.obs;
  Check check = Check();
  TextEditingController productCountController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController cashPaymentController = TextEditingController();
  String factorNumber = '-1';

  RxBool customerSelected = false.obs;
  Rx<Customer> customer = Customer().obs;
  Factor? newFactor;

  @override
  void onInit() {
    super.onInit();
    getFactorNumber();
  }

  @override
  onClose() {
    super.onClose();
    productCountController.dispose();
    productPriceController.dispose();
    cashPaymentController.dispose();
  }

  getFactorNumber() {
    var box = Hive.lazyBox<Factor>(factorBox);
    if (box.isEmpty) {
      factorNumber = '1';
    } //
    else {
      factorNumber = (box.keys.last + 1).toString();
    }
  }

  void selectProduct(context) async {
    Product product = await Get.toNamed(
      Routes.allProductScreen,
      arguments: true,
    );
    switch (typeOfFactor) {
      case TypeOfFactor.oneSale:
        productPriceController.text = '${product.priceOfOneSale}'.seRagham();
        break;
      case TypeOfFactor.buy:
        productPriceController.text = '${product.priceOfBuy}'.seRagham();
        break;
      case TypeOfFactor.sale:
        productPriceController.text = '${product.priceOfMajorSale}'.seRagham();
        break;
      case TypeOfFactor.returnOfSale:
        productPriceController.text = '${product.priceOfMajorSale}'.seRagham();
        break;
      case TypeOfFactor.returnOfBuy:
        productPriceController.text = '${product.priceOfBuy}'.seRagham();
        break;
    }
    StaticMethods.inputProductCount(
      product: product,
      onConfirm: () {
        addProductToFactor(
          product,
          StaticMethods.removeSeparatorFromNumber(productCountController,
              toDouble: true),
          StaticMethods.removeSeparatorFromNumber(productPriceController),
        );
      },
      productCountController: productCountController,
      productPriceController: productPriceController,
    );
  }

  void addProductToFactor(Product product, double count, int price) {
    Get.back();
    productCountController.clear();
    productPriceController.clear();
    FactorRow row = FactorRow(
      productName: product.name!,
      productCount: count,
      productPrice: price,
      productUnit: unitListName(product.mainUnit!),
    );
    if (listFactorRow
        .any((factorRow) => factorRow.productName == row.productName)) {
      int rowIndex = listFactorRow
          .indexWhere((factorRow) => factorRow.productName == row.productName);
      row.productCount =
          row.productCount + listFactorRow[rowIndex].productCount;
      listFactorRow[rowIndex] = row;
    } //
    else {
      listFactorRow.add(row);
    }
    int sum = 0;
    for (var item in listFactorRow) {
      sum += item.productSum;
    }
    factorSum.value = sum.toString();
  }

  bool willPop() {
    if (listFactorRow.isEmpty) {
      return true;
    } //
    else {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'شما یک فاکتور دارید که آن را ذخیره نکرده اید.',
      );
      return false;
    }
  }

  String unitListName(Unit item) {
    switch (item) {
      case Unit.number:
        return 'عدد';
      case Unit.box:
        return 'کارتن';
      case Unit.branch:
        return 'شاخه';
      case Unit.meter:
        return 'متر';
      case Unit.packet:
        return 'بسته';
      case Unit.squareMeters:
        return 'متر مربع';
    }
  }

  onRowTapped(FactorRow row, int index) {
    updateRow(row, index);
  }

  onRowLongPressed(context, FactorRow row, int index) {
    StaticMethods.productBottomSheet(
      context,
      name: row.productName,
      onEditTap: () {
        Get.back();
        updateRow(row, index);
      },
      onDeleteTap: () {
        Get.back();
        listFactorRow.removeAt(index);
      },
    );
  }

  updateRow(FactorRow row, int index) {
    productCountController.text = row.productCount.toString();
    productPriceController.text = row.productPrice.toString();
    Product product = Hive.box<Product>(allProductBox)
        .values
        .firstWhere((Product product) => product.name == row.productName);
    StaticMethods.inputProductCount(
      product: product,
      onConfirm: () {
        double count = StaticMethods.removeSeparatorFromNumber(
          productCountController,
          toDouble: true,
        );
        int price =
            StaticMethods.removeSeparatorFromNumber(productPriceController);
        Get.back();
        productCountController.clear();
        productPriceController.clear();
        FactorRow newRow = FactorRow(
          productName: row.productName,
          productCount: count,
          productPrice: price,
          productUnit: row.productUnit,
        );
        listFactorRow[index] = newRow;
        int sum = 0;
        for (var item in listFactorRow) {
          sum += item.productSum;
        }
        factorSum.value = sum.toString();
      },
      productCountController: productCountController,
      productPriceController: productPriceController,
    );
  }

  void selectCustomer() async {
    customer.value = await Get.toNamed(
      Routes.customersScreen,
      arguments: true,
    );
    if (customer.value != null) {
      customerSelected.value = true;
    }
  }

  Future<bool> saveFactor() async {
    var factorsBox = Hive.lazyBox<Factor>(factorBox);
    if (typeOfFactor != TypeOfFactor.oneSale) {
      if (customer.value.name == null) {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: typeOfFactor == TypeOfFactor.buy ||
                  typeOfFactor == TypeOfFactor.returnOfBuy
              ? 'فروشنده نمی تواند خالی باشد.\nفروشنده را انتخاب کنید.'
              : 'خریدار نمی تواند خالی باشد.\nخریدار را انتخاب کنید.',
        );
        return false;
      }
    }
    var productsBox = Hive.box<Product>(allProductBox);
    bool saveFactor = false;
    if (typeOfFactor == TypeOfFactor.buy ||
        typeOfFactor == TypeOfFactor.returnOfSale) {
      saveFactor = true;
    } //
    else {
      for (var item in listFactorRow) {
        for (var product in productsBox.values) {
          if (item.productName == product.name!) {
            if (product.count! - item.productCount < 0) {
              StaticMethods.showSnackBar(
                title: 'خطا',
                description:
                    'موجودی محصول ${product.name} کمتر از مقداری ایست که در فاکتور وارد کرده اید.\n'
                    'لطفا مقدار وارد شده در فاکتور را تصحیح کنید.',
                duration: const Duration(seconds: 5),
              );
              saveFactor = false;
              return false;
            } //
            else {
              saveFactor = true;
            }
          }
        }
      }
    }
    if (saveFactor) {
      for (var item in listFactorRow) {
        for (var product in productsBox.values) {
          if (item.productName == product.name!) {
            if (typeOfFactor == TypeOfFactor.buy ||
                typeOfFactor == TypeOfFactor.returnOfSale) {
              product.count =
                  StaticMethods.roundDouble(product.count! + item.productCount);
              if (typeOfFactor == TypeOfFactor.buy) {
                product.priceOfBuy = item.productPrice;
              }
            } //
            else {
              product.count =
                  StaticMethods.roundDouble(product.count! - item.productCount);
            }
            product.save();
          }
        }
      }
      newFactor = Factor(
        factorDate: DateTime.now(),
        factorRows: [],
        factorSum: typeOfFactor == TypeOfFactor.buy ||
                typeOfFactor == TypeOfFactor.returnOfSale
            ? int.parse(factorSum.value)
            : -int.parse(factorSum.value),
        typeOfFactor: typeOfFactor,
        customer: customer.value,
      );
      newFactor!.factorRows!.addAll(listFactorRow.value);
      int index = await factorsBox.add(newFactor!);
      newFactor!.id = index;
      await newFactor!.save();
      listFactorRow.clear();
      factorSum.value = '-1';
      Get.back();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'فاکتور شما با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
      return true;
    }
    return false;
  }

  void saveToBill() async {
    bool status = await saveFactor();
    if (status) {
      await saveCheck();
      var billBox = Hive.lazyBox<Bill>(billsBox);
      Cash cash = Cash(
        cashAmount: typeOfFactor == TypeOfFactor.buy ||
                typeOfFactor == TypeOfFactor.returnOfSale
            ? -cashAmount.value
            : cashAmount.value,
        cashDate: DateTime.now(),
      );
      int key = billBox.keys.firstWhere((key) => key == customer.value.id);
      Bill? newBill = await billBox.get(key);
      newBill!.factor!.add(newFactor!);
      if (checkAmount.value != 0) {
        newBill.check!.add(check);
      }
      if (cashAmount.value != 0) {
        newBill.cash!.add(cash);
      }
      await newBill.save();
    }
  }

  void cashPaymentTapped() {
    cashPaymentController.text = cashAmount.value.toString();
    StaticMethods.showCashPaymentDialog(
      cashPaymentController,
      () {
        Get.back();
        cashAmount.value =
            StaticMethods.removeSeparatorFromNumber(cashPaymentController);
        cashPaymentController.clear();
      },
    );
  }

  void checkPaymentTapped() async {
    String typeOfCheck = typeOfFactor == TypeOfFactor.buy ||
            typeOfFactor == TypeOfFactor.returnOfSale
        ? 'send'
        : 'received';
    if (customer.value.id == null) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'لطفا طرف حساب را انتخاب کنید.',
      );
    } //
    else {
      check = await Get.toNamed(
        Routes.createCheckScreen,
        parameters: {
          'from_factor': 'true',
          'customer_id': customer.value.id.toString(),
          'type_of_check': typeOfCheck,
        },
      );
      checkAmount.value = check.checkAmount!.abs();
    }
  }

  Future<void> saveCheck() async {
    var checkBox = Hive.box<Check>(checksBox);
    int index = await checkBox.add(check);
    check.id = index;
    await check.save();
  }
}

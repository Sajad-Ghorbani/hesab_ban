import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/models/factor_row.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hive/hive.dart';

import '../models/product_model.dart';
import '../routes/app_pages.dart';
import '../ui/theme/app_colors.dart';

class FactorController extends GetxController {
  TypeOfFactor typeOfFactor = Get.arguments;
  RxList<FactorRow> listFactorRow = <FactorRow>[].obs;
  RxString factorSum = '-1'.obs;
  TextEditingController productCountController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  String factorNumber = '-1';

  @override
  void onInit() {
    super.onInit();
    getFactorNumber();
  }

  getFactorNumber() {
    Box<Factor>? box;
    switch (typeOfFactor) {
      case TypeOfFactor.oneSell:
        box = Hive.box<Factor>(oneSellFactorBox);
        break;
      case TypeOfFactor.buy:
        box = Hive.box<Factor>(buyFactorBox);
        break;
      case TypeOfFactor.sell:
        box = Hive.box<Factor>(sellFactorBox);
        break;
    }
    if (box.isEmpty) {
      factorNumber = '1';
    } //
    else {
      factorNumber = (box.values.last.id! + 1).toString();
    }
  }

  void saveFactor(BuildContext context) {
    switch (typeOfFactor) {
      case TypeOfFactor.oneSell:
        saveOneSellFactor();
        break;
      case TypeOfFactor.buy:
      case TypeOfFactor.sell:
    }
  }

  void selectProduct(context) async {
    Product product = await Get.toNamed(
      Routes.allProductScreen,
      arguments: true,
    );
    productPriceController.text = product.priceOfOneSell.toString();
    StaticMethods.inputProductCount(
      product: product,
      onConfirm: () {
        addProductToFactor(
          product,
          int.parse(productCountController.text),
          int.parse(productPriceController.text),
        );
      },
      productCountController: productCountController,
      productPriceController: productPriceController,
    );
  }

  void addProductToFactor(Product product, int count, int price) {
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

  void saveOneSellFactor() async {
    var factorBox = Hive.box<Factor>(oneSellFactorBox);
    var productsBox = Hive.box<Product>(allProductBox);
    bool saveFactor = false;
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
            return;
          } //
          else {
            saveFactor = true;
          }
        }
      }
    }
    if (saveFactor) {
      for (var item in listFactorRow) {
        for (var product in productsBox.values) {
          if (item.productName == product.name!) {
            product.count = product.count! - item.productCount;
            product.save();
          }
        }
      }
      Factor oneSellFactor = Factor(
        factorDate: DateTime.now(),
        factorRows: listFactorRow,
        factorSum: int.parse(factorSum.value),
        typeOfFactor: typeOfFactor,
      );
      int index = await factorBox.add(oneSellFactor);
      oneSellFactor.id = index;
      oneSellFactor.save();
      listFactorRow.clear();
      factorSum.value = '-1';
      Get.back();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'فاکتور شما با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
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
        int count = int.parse(productCountController.text);
        int price = int.parse(productPriceController.text);
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
}

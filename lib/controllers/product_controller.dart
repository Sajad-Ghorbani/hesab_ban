import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/data/models/product_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../data/models/category_model.dart';

class ProductController extends GetxController {
  List<DropdownMenuItem<int>> productUnitList = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController productBuyController = TextEditingController();
  TextEditingController productOneSaleController = TextEditingController();
  TextEditingController productMajorSaleController = TextEditingController();
  TextEditingController productCountController = TextEditingController();

  int productMainUnit = 0;
  String productCategoryName = Get.parameters['categoryName']!;

  var productBox = Hive.box<Product>(allProductBox);
  var categoryBox = Hive.box<Category>(productCategoryBox);

  @override
  void onInit() {
    super.onInit();
    productUnitList = getUnitList();
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

  List<DropdownMenuItem<int>> getUnitList() {
    List<DropdownMenuItem<int>> list = [];
    for (var item in Unit.values) {
      list.add(
        DropdownMenuItem(
          child: Text(
            unitListName(item),
          ),
          value: item.index,
        ),
      );
    }
    return list;
  }

  void saveProduct(context) async {
    if (productNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } else if (productBox.values
        .any((element) => element.name == productNameController.text.trim())) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'نام تکراری است',
      );
    } //
    else {
      Product product = Product(
        name: productNameController.text.trim(),
        count: productCountController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productCountController,
                toDouble: true),
        priceOfBuy: productBuyController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productBuyController),
        priceOfOneSale: productOneSaleController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(productOneSaleController),
        priceOfMajorSale: productMajorSaleController.text.isEmpty
            ? 0
            : StaticMethods.removeSeparatorFromNumber(
                productMajorSaleController),
        mainUnit: Unit.values[productMainUnit],
        category: getCurrentCategory(productCategoryName),
      );
      final int key = await productBox.add(product);
      product.id = key;
      await product.save();
      resetProductScreen(context);
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'محصول جدید با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
    }
  }

  Category getCurrentCategory(String categoryName) {
    return categoryBox.values
        .where((element) => element.name == categoryName)
        .first;
  }

  void resetProductScreen(context) {
    FocusScope.of(context).unfocus();
    productNameController.clear();
    productBuyController.clear();
    productOneSaleController.clear();
    productMajorSaleController.clear();
    productCountController.clear();
  }

  void updateProduct(context, Product product) async {
    if (productNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      product.name = productNameController.text.trim();
      product.count = productCountController.text.isEmpty
          ? null
          : StaticMethods.removeSeparatorFromNumber(productCountController,
              toDouble: true);
      product.priceOfBuy = productBuyController.text.isEmpty
          ? null
          : StaticMethods.removeSeparatorFromNumber(productBuyController);
      product.priceOfOneSale = productOneSaleController.text.isEmpty
          ? null
          : StaticMethods.removeSeparatorFromNumber(productOneSaleController);
      product.priceOfMajorSale = productMajorSaleController.text.isEmpty
          ? null
          : StaticMethods.removeSeparatorFromNumber(productMajorSaleController);
      product.mainUnit = Unit.values[productMainUnit];
      product.save();
      Get.back();
      resetProductScreen(context);
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'محصول ${product.name} با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
    }
  }
}

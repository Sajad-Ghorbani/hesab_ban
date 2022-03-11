import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/category_model.dart';

class ProductController extends GetxController {
  List<DropdownMenuItem<int>> productUnitList = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController productBuyController = TextEditingController();
  TextEditingController productOneSellController = TextEditingController();
  TextEditingController productMajorSellController = TextEditingController();
  TextEditingController productCountController = TextEditingController();


  int productMainUnit = 0;
  String productCategoryName = Get.parameters['categoryName']!;

  var productBox = Hive.box<Product>(allProductBox);
  var categoryBox = Hive.box<Category>(productCategoryBox);

  @override
  void onInit() {
    // TODO: implement onInit
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
            : int.parse(productCountController.text.trim()),
        priceOfBuy: productBuyController.text.isEmpty
            ? 0
            : int.parse(productBuyController.text.trim()),
        priceOfOneSell: productOneSellController.text.isEmpty
            ? 0
            : int.parse(productOneSellController.text.trim()),
        priceOfMajorSell: productMajorSellController.text.isEmpty
            ? 0
            : int.parse(productMajorSellController.text.trim()),
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
    productOneSellController.clear();
    productMajorSellController.clear();
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
          : int.parse(productCountController.text.trim());
      product.priceOfBuy = productBuyController.text.isEmpty
          ? null
          : int.parse(productBuyController.text.trim());
      product.priceOfOneSell = productOneSellController.text.isEmpty
          ? null
          : int.parse(productOneSellController.text.trim());
      product.priceOfMajorSell = productMajorSellController.text.isEmpty
          ? null
          : int.parse(productMajorSellController.text.trim());
      product.mainUnit = Unit.values[productMainUnit];
      product.save();
      resetProductScreen(context);
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'محصول ${product.name} با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
    }
  }
}

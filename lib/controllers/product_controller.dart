import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/screens/product_folder_screen.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../models/category_model.dart';

class ProductController extends GetxController {
  List<DropdownMenuItem<int>> productUnitList = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController productBuyController = TextEditingController();
  TextEditingController productOneSellController = TextEditingController();
  TextEditingController productMajorSellController = TextEditingController();
  TextEditingController productCountController = TextEditingController();
  TextEditingController productUnitRatioController = TextEditingController();

  TextEditingController categoryNameController = TextEditingController();

  int productMainUnit = 0;
  int? productSubCountingUnit;
  RxList<Category> productCategory = <Category>[].obs;
  RxList<Product> allProducts = <Product>[].obs;
  RxList<Product> allProductCategory = <Product>[].obs;
  RxList<Product> mainProduct = <Product>[].obs;
  String productCategoryName = defaultCategoryName;

  RxBool showProductsFab = true.obs;
  RxBool showCategoryProductsFab = true.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    productUnitList = getUnitList();
    productCategory.value = getCategoryList();
    allProducts.value = getAllProducts();
    mainProduct.value = getProductsOfCategory(defaultCategoryName);
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
    var productBox = Hive.box<Product>(allProductBox);
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
        unitRatio: productUnitRatioController.text.isEmpty
            ? null
            : double.parse(productUnitRatioController.text.trim()),
        mainUnit: Unit.values[productMainUnit],
        subCountingUnit: productSubCountingUnit == null
            ? null
            : Unit.values[productSubCountingUnit!],
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
      allProducts.value = productBox.values.toList();
      allProductCategory.value = getProductsOfCategory(productCategoryName);
      mainProduct.value = getProductsOfCategory(defaultCategoryName);
    }
  }

  Category getCurrentCategory(String categoryName) {
    var categoryBox = Hive.box<Category>(productCategoryBox);

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
    productUnitRatioController.clear();
    productCountController.clear();
  }

  List<Category> getCategoryList() {
    var categoryBox = Hive.box<Category>(productCategoryBox);
    return categoryBox.values.toList();
  }

  List<Product> getAllProducts() {
    var productsBox = Hive.box<Product>(allProductBox);
    return productsBox.values.toList();
  }

  List<Product> getProductsOfCategory(String categoryName) {
    var productsBox = Hive.box<Product>(allProductBox);
    List<Product> list = productsBox.values
        .where((element) => element.category!.name == categoryName)
        .toList();
    return list;
  }

  void navigateToCategory(context, String categoryName) async {
    productCategoryName = categoryName;
    allProductCategory.value = getProductsOfCategory(productCategoryName);
    await pushNewScreen(context, screen: const ProductFolderScreen());
    productCategoryName = defaultCategoryName;
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
      var categoryBox = Hive.box<Category>(productCategoryBox);
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
      productCategory.value = getCategoryList();
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
      productCategory.value = getCategoryList();
      categoryNameController.clear();
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'دسته $categoryName با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
    }
  }

  void deleteCategory(Category category) async {
    var productBox = Hive.box<Product>(allProductBox);
    for (var item in productBox.values) {
      if (item.category!.name == category.name) {
        await item.delete();
      }
    }
    await category.delete();
    productCategory.value = getCategoryList();
  }

  void deleteProduct(Product product) async {
    await product.delete();
    var productBox = Hive.box<Product>(allProductBox);
    allProducts.value = productBox.values.toList();
    allProductCategory.value = getProductsOfCategory(productCategoryName);
    mainProduct.value = getProductsOfCategory(defaultCategoryName);
  }

  void updateProduct(context, Product product) async {
    var productBox = Hive.box<Product>(allProductBox);
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
      product.unitRatio = productUnitRatioController.text.isEmpty
          ? null
          : double.parse(productUnitRatioController.text.trim());
      product.mainUnit = Unit.values[productMainUnit];
      product.subCountingUnit = productSubCountingUnit == null
          ? null
          : Unit.values[productSubCountingUnit!];
      product.save();
      resetProductScreen(context);
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'محصول ${product.name} با موفقیت ویرایش شد.',
        color: kLightGreenColor,
      );
      allProducts.value = productBox.values.toList();
      allProductCategory.value = getProductsOfCategory(productCategoryName);
      mainProduct.value = getProductsOfCategory(defaultCategoryName);
    }
  }

  void backToHome(BuildContext context) {
    productCategoryName = defaultCategoryName;
    Navigator.pop(context);
  }
}

import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/static_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProductController extends GetxController {
  List<DropdownMenuItem<int>> productUnitList = [];

  TextEditingController productNameController = TextEditingController();
  TextEditingController productBuyController = TextEditingController();
  TextEditingController productOneSellController = TextEditingController();
  TextEditingController productMajorSellController = TextEditingController();
  TextEditingController productCountController = TextEditingController();
  TextEditingController productUnitRatioController = TextEditingController();

  TextEditingController folderNameController = TextEditingController();

  int productMainUnit = 0;
  int? productSubCountingUnit;
  RxList<String> productFolder = <String>[].obs;
  RxList<Product> allProducts = <Product>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    productUnitList = getUnitList();
    productFolder.value = getFolderList();
    allProducts.value = getAllProducts();
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
      StaticMethods.showSnackBar(title: 'خطا', description: 'نام تکراری است');
    } //
    else {
      Product product = Product(
        name: productNameController.text.trim(),
        count: productCountController.text.isEmpty
            ? null
            : int.parse(productCountController.text.trim()),
        priceOfBuy: productBuyController.text.isEmpty
            ? null
            : int.parse(productBuyController.text.trim()),
        priceOfOneSell: productOneSellController.text.isEmpty
            ? null
            : int.parse(productOneSellController.text.trim()),
        priceOfMajorSell: productMajorSellController.text.isEmpty
            ? null
            : int.parse(productMajorSellController.text.trim()),
        unitRatio: productUnitRatioController.text.isEmpty
            ? null
            : double.parse(productUnitRatioController.text.trim()),
        mainUnit: Unit.values[productMainUnit],
        subCountingUnit: productSubCountingUnit == null
            ? null
            : Unit.values[productSubCountingUnit!],
      );
      final int key = await productBox.add(product);
      product.id = key;
      await product.save();
      resetProductScreen(context);
    }
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

  List<String> getFolderList() {
    var folderBox = Hive.box<String>(productFolderNameBox);
    return folderBox.values.toList();
  }

  List<Product> getAllProducts() {
    var productsBox = Hive.box<Product>(allProductBox);
    return productsBox.values.toList();
  }

  void getFolderProduct(context,int folderNumber)async{
    var productsBox = await Hive.openBox<Product>('folder$folderNumber');
    allProducts.value = productsBox.values.toList();
    // pushNewScreen(context, screen: const ProductScreen());
  }

  void addNewFolder() async {
    String folderName = folderNameController.text.trim();
    if (folderName.isEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        StaticMethods.showSnackBar(
            title: 'خطا', description: 'لطفا نام را وارد کنید.');
      });
    } //
    else {
      var folderBox = Hive.box<String>(productFolderNameBox);
      if (folderBox.isEmpty) {
        folderBox.add('$folderName/0');
        await Hive.openBox<Product>('folder0');
      } //
      else {
        int folderNumber = int.parse(folderBox.values.last.split('/').last);
        folderBox.add('$folderName/${folderNumber + 1}');
        await Hive.openBox<Product>('folder${folderNumber + 1}');
      }
      productFolder.value = getFolderList();
      folderNameController.clear();
    }
  }

  void updateNewFolder(int folderNumber)async {
    String folderName = folderNameController.text.trim();
    if (folderName.isEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        StaticMethods.showSnackBar(
            title: 'خطا', description: 'لطفا نام را وارد کنید.');
      });
    } //
    else {
      var folderBox = Hive.box<String>(productFolderNameBox);
      await folderBox.putAt(folderNumber, '$folderName/$folderNumber');
      productFolder.value = getFolderList();
      folderNameController.clear();
    }
  }

  void deleteFolder(int folderNumber) async{
    var folderBox = Hive.box<String>(productFolderNameBox);
    await folderBox.deleteAt(folderNumber);
    var oldFolderBox = Hive.box<Product>('folder$folderNumber');
    await oldFolderBox.deleteFromDisk();
    productFolder.value = getFolderList();
  }
}

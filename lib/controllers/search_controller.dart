import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/category_model.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SearchController extends GetxController {
  TextEditingController searchController = TextEditingController();
  List<Product> productList = [];
  List<Category> categoryList = [];

  RxBool searchEmpty = true.obs;

  void search(String text) {
    var productBox = Hive.box<Product>(allProductBox);
    var categoryBox = Hive.box<Category>(productCategoryBox);
    categoryList.clear();
    productList.clear();

    if (searchController.text.length < 2) {
      categoryList.clear();
      productList.clear();
    } //
    else {
      for (var item in categoryBox.values) {
        if (item.name!.contains(text)) {
          categoryList.add(item);
        }
      }

      for (var item in productBox.values) {
        if (item.name!.contains(text)) {
          productList.add(item);
        }
      }
    }

    if(categoryList.isEmpty && productList.isEmpty){
      searchEmpty.value = true;
    }//
    else{
      searchEmpty.value = false;
    }

    update();
  }

  void clearScreen() {
    searchController.clear();
    categoryList.clear();
    productList.clear();
    update();
  }
}

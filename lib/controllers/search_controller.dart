import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/category_model.dart';
import 'package:accounting_app/models/check_model.dart';
import 'package:accounting_app/models/customer_model.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SearchController extends GetxController {
  TextEditingController searchController = TextEditingController();
  List<Product> productList = [];
  List<Category> categoryList = [];
  List<Customer> customerList = [];
  List<Check> checkList = [];

  RxBool searchEmpty = true.obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  void searchCustomer(String text) {
    var customerBox = Hive.box<Customer>(customersBox);
    customerList.clear();

    if (searchController.text.length < 2) {
      customerList.clear();
    } //
    else {
      for (var item in customerBox.values) {
        if (item.name!.contains(text)) {
          customerList.add(item);
        }
      }
    }

    if (customerList.isEmpty) {
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
    }

    update();
  }

  void clearScreen() {
    searchController.clear();
    categoryList.clear();
    productList.clear();
    customerList.clear();
    update();
  }

  void searchProduct(String text) {
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

    if (categoryList.isEmpty && productList.isEmpty) {
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
    }

    update();
  }

  void searchCheck(String text, TypeOfCheck typeOfCheck) {
    var searchCheckBox = Hive.box<Check>(checksBox);

    checkList.clear();

    if (searchController.text.length < 2) {
      checkList.clear();
    } //
    else {
      for (var item in searchCheckBox.values) {
        if (item.typeOfCheck == typeOfCheck &&
            item.customerCheck!.name!.contains(text)) {
          checkList.add(item);
        }
      }
    }

    if (checkList.isEmpty) {
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
    }

    update();
  }
}

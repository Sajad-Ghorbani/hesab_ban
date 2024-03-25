import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/category_entity.dart';
import 'package:hesab_ban/app/features/feature_product/domain/entities/product_entity.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';

class SearchBarController extends GetxController {
  TextEditingController searchController = TextEditingController();
  List<ProductEntity> productList = [];
  List<CategoryEntity> categoryList = [];
  List<CustomerEntity> customerList = [];
  List<FactorEntity> factorList = [];
  List<CheckEntity> checkList = [];
  List<CashEntity> cashList = [];

  RxBool searchEmpty = true.obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  void searchCustomer(String text, List<CustomerEntity> customers) {
    customerList.clear();
    if (searchController.text.isEmpty) {
      customerList.clear();
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
      for (var item in customers) {
        if (item.name!.toLowerCase().contains(text.toLowerCase()) ||
            (item.description != null &&
                item.description!.toLowerCase().contains(text.toLowerCase())) ||
            (item.phoneNumber1 != null && item.phoneNumber1!.contains(text)) ||
            (item.phoneNumber2 != null && item.phoneNumber2!.contains(text))) {
          customerList.add(item);
        }
      }
    }
    update();
  }

  void clearScreen() {
    searchController.clear();
    categoryList.clear();
    customerList.clear();
    productList.clear();
    factorList.clear();
    checkList.clear();
    cashList.clear();
    update();
  }

  void searchProduct(String text) {
    List<CategoryEntity> categories = Get.find<ProductController>().categories;
    List<ProductEntity> products = Get.find<ProductController>().products;
    categoryList.clear();
    productList.clear();
    if (searchController.text.isEmpty) {
      categoryList.clear();
      productList.clear();
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
      for (var item in categories) {
        if (item.name!.toLowerCase().contains(text.toLowerCase())) {
          categoryList.add(item);
        }
      }
      for (var item in products) {
        if (item.name!.toLowerCase().contains(text.toLowerCase())) {
          productList.add(item);
        }
      }
    }
    update();
  }

  void searchCheck(String text, TypeOfCheck typeOfCheck) {
    List<CheckEntity> checks = Get.find<CheckController>().checks;
    checkList.clear();
    if (searchController.text.isEmpty) {
      checkList.clear();
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
      for (var item in checks) {
        if (item.typeOfCheck == typeOfCheck &&
            (item.customerCheck!.name!
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item.checkNumber!.contains(text))) {
          checkList.add(item);
        }
      }
    }
    update();
  }

  void searchCash(String text, List<CashEntity> cashes) {
    cashList.clear();
    if (searchController.text.isEmpty) {
      cashList.clear();
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
      for (var item in cashes) {
        if (item.customer!.name!.toLowerCase().contains(text.toLowerCase()) ||
            item.cashAmount!.abs().toString().contains(text)) {
          cashList.add(item);
        }
      }
    }
    update();
  }

  void searchFactor(String text, List<FactorEntity> factors) {
    factorList.clear();
    if (searchController.text.isEmpty) {
      factorList.clear();
      searchEmpty.value = true;
    } //
    else {
      searchEmpty.value = false;
      for (var item in factors) {
        if (item.customer!.name!.toLowerCase().contains(text.toLowerCase()) ||
            item.id!.toString().contains(text)) {
          factorList.add(item);
        }
      }
    }
    update();
  }
}

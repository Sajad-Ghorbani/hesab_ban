import 'package:accounting_app/constants.dart';
import 'package:accounting_app/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../static_methods.dart';

class CustomerController extends GetxController {
  Customer? customer = Get.arguments;
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerPhone2Controller = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerBalanceController = TextEditingController();

  ScrollController scrollController = ScrollController();
  RxBool showCustomersFab = true.obs;

  late final Box customerBox;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    customerBox = Hive.box<Customer>(customersBox);
  }

  void saveCustomer(BuildContext context) async {
    var customerBox = Hive.box<Customer>(customersBox);
    if (customerNameController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      Customer newCustomer = Customer(
        name: customerNameController.text.trim(),
        phoneNumber1: customerPhoneController.text.trim(),
        phoneNumber2: customerPhone2Controller.text.trim(),
        address: customerAddressController.text.trim(),
        initialAccountBalance: customerBalanceController.text.trim().isEmpty
            ? 0
            : int.parse(customerBalanceController.text.trim()),
      );
      final int key = await customerBox.add(newCustomer);
      newCustomer.id = key;
      await newCustomer.save();
      resetCustomerScreen(context);
    }
  }

  void updateCustomer(BuildContext context, Customer customer) async {
    if (customerNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      customer.name = customerNameController.text;
      customer.phoneNumber1 = customerPhoneController.text.trim();
      customer.phoneNumber2 = customerPhone2Controller.text.trim();
      customer.address = customerAddressController.text.trim();
      customer.initialAccountBalance =
          customerBalanceController.text.trim().isEmpty
              ? 0
              : int.parse(customerBalanceController.text.trim());
      customer.save();
      resetCustomerScreen(context);
    }
  }

  void deleteCustomer(){

  }

  void resetCustomerScreen(BuildContext context) {
    FocusScope.of(context).unfocus();
    customerNameController.clear();
    customerPhoneController.clear();
    customerPhone2Controller.clear();
    customerAddressController.clear();
    customerBalanceController.clear();
  }
}

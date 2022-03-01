import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../static_methods.dart';

class CustomerController extends GetxController {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerPhone2Controller = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerBalanceController = TextEditingController();

  late final Box customerBox;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    customerBox = Hive.box<Customer>(customersBox);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerPhone2Controller.dispose();
    customerAddressController.dispose();
    customerBalanceController.dispose();
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
      StaticMethods.showSnackBar(
        title: 'تبریک',
        description: 'کاربر ${newCustomer.name} با موفقیت ثبت شد.',
        color: kLightGreenColor,
      );
      resetCustomerScreen(context);
    }

    update();
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

    update();
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

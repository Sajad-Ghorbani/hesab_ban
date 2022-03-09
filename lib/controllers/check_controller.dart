import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/bill_model.dart';

class CheckController extends GetxController {
  TextEditingController checkBankNameController = TextEditingController();
  TextEditingController checkNumberController = TextEditingController();
  TextEditingController checkAmountController = TextEditingController();

  RxString checkDueDateLabel = '-1'.obs;
  RxString checkDeliveryDateLabel = '-1'.obs;
  DateTime? checkDueDate;
  DateTime? checkDeliveryDate;

  TypeOfCheck? typeOfCheck;
  Customer? checkCustomer;

  Check? check = Get.arguments;
  String? fromFactor = Get.parameters['from_factor'];

  @override
  onInit() {
    super.onInit();
    if (fromFactor == null) {
      showSelectCustomerBottomSheets();
    } //
    else {
      setCheckDetailFromFactor();
    }
  }

  setCheckDetailFromFactor() {
    var customerBox = Hive.box<Customer>(customersBox);
    String type = Get.parameters['type_of_check']!;
    String customerId = Get.parameters['customer_id']!;
    for (var item in TypeOfCheck.values) {
      if (item.name == type) {
        typeOfCheck = item;
      }
    }
    for (var item in customerBox.values) {
      if (item.id == int.parse(customerId)) {
        checkCustomer = item;
      }
    }
  }

  @override
  onClose() {
    super.onClose();
    checkBankNameController.dispose();
    checkNumberController.dispose();
    checkAmountController.dispose();
  }

  setTypeOfCheck(bool isMe) {
    if (isMe) {
      typeOfCheck = TypeOfCheck.send;
    } //
    else {
      typeOfCheck = TypeOfCheck.received;
    }
    Get.back();
  }

  List<DropdownMenuItem<int>> setCustomerList() {
    var customerBox = Hive.box<Customer>(customersBox);
    List<DropdownMenuItem<int>> list = [];
    for (var item in customerBox.values) {
      list.add(
        DropdownMenuItem(
          child: Text(item.name!),
          value: item.id,
        ),
      );
    }
    return list;
  }

  void setCustomerCheck(int customerId) {
    var customerBox = Hive.box<Customer>(customersBox);
    for (var item in customerBox.values) {
      if (item.id == customerId) {
        checkCustomer = item;
      }
    }
    Get.back();
  }

  void saveCheck(BuildContext context) async {
    String bankName = checkBankNameController.text.trim();
    String checkNumber = checkNumberController.text.trim();
    if (bankName.isEmpty ||
        checkNumber.isEmpty ||
        checkAmountController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا فرم را کامل کنید.');
      return;
    } //
    else if (checkDueDate == null || checkDeliveryDate == null) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'تاریخ چک را وارد کنید.');
      return;
    } //
    else if (checkDueDate!.compareTo(checkDeliveryDate!) == 1) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description:
            'تاریخ های چک به درستی وارد نشده.\nتاریخ سررسید چک قبل از تاریخ تحویل چک می باشد.',
        duration: const Duration(seconds: 4),
      );
      return;
    } //
    else if (checkCustomer == null) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'گیرنده چک را مشخص نکردید.');
      Future.delayed(const Duration(seconds: 2), () {
        StaticMethods.selectCustomerCheck(
          title: typeOfCheck == TypeOfCheck.send
              ? 'گیرنده چک را انتخاب کنید'
              : 'مشتری را انتخاب کنید',
          dropDownList: setCustomerList(),
          onSelectCustomer: (int? value) {
            setCustomerCheck(value!);
          },
        );
      });
    } //
    else if (typeOfCheck == null) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'صادر کننده چک را مشخص نکردید.');
      Future.delayed(const Duration(seconds: 2), () {
        StaticMethods.selectCheckDetails(
          onMeTap: () {
            setTypeOfCheck(true);
          },
          onCustomerTap: () {
            setTypeOfCheck(false);
          },
        );
      });
    } //
    else {
      int amount = typeOfCheck == TypeOfCheck.received
          ? int.parse(checkAmountController.text.trim())
          : -int.parse(checkAmountController.text.trim());
      var checkBox = Hive.box<Check>(checksBox);
      Check newCheck = Check(
        bankName: bankName,
        checkNumber: checkNumber,
        checkAmount: amount,
        checkDueDate: checkDueDate,
        checkDeliveryDate: checkDeliveryDate,
        customerCheck: checkCustomer,
        typeOfCheck: typeOfCheck,
      );
      if (fromFactor != null) {
        Get.back(result: newCheck);
        return;
      }
      int index = await checkBox.add(newCheck);
      newCheck.id = index;
      await newCheck.save();
      await addToCustomerBill(newCheck);
      resetCheckScreen(context);
      StaticMethods.showSnackBar(
        title: 'تبریک!',
        description: 'ثبت چک با موفقیت انجام شد.',
        color: kLightGreenColor,
      );
    }
  }

  void updateCheck(BuildContext context, Check check) {}

  void resetCheckScreen(BuildContext context) {
    FocusScope.of(context).unfocus();
    checkBankNameController.clear();
    checkNumberController.clear();
    checkAmountController.clear();
    checkDueDate = null;
    checkDueDateLabel.value = '-1';
    checkDeliveryDate = null;
    checkDeliveryDateLabel.value = '-1';
    checkCustomer = null;
    typeOfCheck = null;
  }

  void showSelectCustomerBottomSheets() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await StaticMethods.selectCheckDetails(
          onMeTap: () {
            setTypeOfCheck(true);
          },
          onCustomerTap: () {
            setTypeOfCheck(false);
          },
        );
        Future.delayed(
          const Duration(milliseconds: 200),
          () async {
            await StaticMethods.selectCustomerCheck(
              title: typeOfCheck == TypeOfCheck.send
                  ? 'گیرنده چک را انتخاب کنید'
                  : 'مشتری را انتخاب کنید',
              dropDownList: setCustomerList(),
              onSelectCustomer: (int? value) {
                setCustomerCheck(value!);
              },
            );
          },
        );
      },
    );
  }

  addToCustomerBill(Check check) async {
    var billBox = Hive.box<Bill>(billsBox);
    bool billExist = billBox.keys.any((key) => key == checkCustomer!.id);
    if (billExist) {
      Bill newBill =
          billBox.values.firstWhere((bill) => bill.id == checkCustomer!.id);
      newBill.check!.add(check);
      await newBill.save();
    } //
    else {
      Bill newBill = Bill(
        id: checkCustomer!.id,
        customer: checkCustomer!,
        check: [check],
      );
      await billBox.put(checkCustomer!.id, newBill);
    }
  }
}

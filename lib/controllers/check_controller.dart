import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/data/models/bank_model.dart';
import 'package:hesab_ban/data/models/check_model.dart';
import 'package:hesab_ban/data/models/customer_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../data/models/bill_model.dart';

class CheckController extends GetxController {
  TextEditingController checkNumberController = TextEditingController();
  TextEditingController checkAmountController = TextEditingController();

  RxString checkDueDateLabel = '-1'.obs;
  RxString checkBankName = bankList[0].name!.obs;
  RxString checkDeliveryDateLabel = '-1'.obs;
  DateTime? checkDueDate;
  DateTime? checkDeliveryDate;

  TypeOfCheck? typeOfCheck;
  Customer? checkCustomer;

  Check? check = Get.arguments;
  String? fromFactor = Get.parameters['from_factor'];
  List<DropdownMenuItem<String>> bankLists = [];

  @override
  onInit() {
    super.onInit();
    if (fromFactor == null) {
      showSelectCustomerBottomSheets();
    } //
    else {
      setCheckDetailFromFactor();
    }
    setBankList();
  }

  setBankList() {
    for (var item in bankList) {
      bankLists.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  color: kWhiteColor,
                ),
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  item.imageAddress!,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(item.name!),
            ],
          ),
          value: item.name!,
        ),
      );
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

  setDateOfCheck(BuildContext context, bool checkDeliverStatus) async {
    var settingsBox = Hive.lazyBox(settingBox);
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali.now() - 30,
      lastDate: Jalali(1450, 9),
    );
    if (pickedDate != null) {
      if (checkDeliverStatus) {
        int hours = await settingsBox.get('notificationHours') ?? 8;
        int minutes = await settingsBox.get('notificationMinutes') ?? 0;
        pickedDate = pickedDate.add(
          hours: hours,
          minutes: minutes,
        );
        checkDeliveryDateLabel.value = pickedDate
            .toJalaliDateTime()
            .split(' ')
            .first
            .toPersianDigit()
            .replaceAll('-', '/');
        checkDeliveryDate = pickedDate.toDateTime();
      } //
      else {
        checkDueDateLabel.value = pickedDate
            .toJalaliDateTime()
            .split(' ')
            .first
            .toPersianDigit()
            .replaceAll('-', '/');
        checkDueDate = pickedDate.toDateTime();
      }
    }
  }

  void saveCheck(BuildContext context) async {
    String checkNumber = checkNumberController.text.trim();
    if (checkBankName.value == '-1' ||
        checkNumber.isEmpty ||
        checkAmountController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
          title: '??????', description: '???????? ?????? ???? ???????? ????????.');
      return;
    } //
    else if (checkDueDate == null || checkDeliveryDate == null) {
      StaticMethods.showSnackBar(
          title: '??????', description: '?????????? ???? ???? ???????? ????????.');
      return;
    } //
    else if (checkDueDate!.compareTo(checkDeliveryDate!) == 1) {
      StaticMethods.showSnackBar(
        title: '??????',
        description:
            '?????????? ?????? ???? ???? ?????????? ???????? ????????.\n?????????? ???????????? ???? ?????? ???? ?????????? ?????????? ???? ???? ????????.',
        duration: const Duration(seconds: 4),
      );
      return;
    } //
    else if (checkCustomer == null) {
      StaticMethods.showSnackBar(
          title: '??????', description: '???????????? ???? ???? ???????? ????????????.');
      Future.delayed(const Duration(seconds: 2), () {
        StaticMethods.selectCustomer(
          title: typeOfCheck == TypeOfCheck.send
              ? '???????????? ???? ???? ???????????? ????????'
              : '?????????? ???? ???????????? ????????',
          dropDownList: setCustomerList(),
          onSelectCustomer: (int? value) {
            setCustomerCheck(value!);
          },
        );
      });
    } //
    else if (typeOfCheck == null) {
      StaticMethods.showSnackBar(
          title: '??????', description: '???????? ?????????? ???? ???? ???????? ????????????.');
      Future.delayed(const Duration(seconds: 2), () {
        StaticMethods.selectDetails(
          title: '???????? ?????????? ???? ???? ???????????? ????????.',
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
          ? StaticMethods.removeSeparatorFromNumber(checkAmountController)
          : -StaticMethods.removeSeparatorFromNumber(checkAmountController);
      var checkBox = Hive.box<Check>(checksBox);
      Check newCheck = Check(
        checkNumber: checkNumber,
        checkAmount: amount,
        checkDueDate: checkDueDate,
        checkDeliveryDate: checkDeliveryDate,
        customerCheck: checkCustomer,
        typeOfCheck: typeOfCheck,
        checkBank:
            bankList.firstWhere((bank) => bank.name == checkBankName.value),
      );
      if (fromFactor != null) {
        Get.back(result: newCheck);
        return;
      }
      int index = await checkBox.add(newCheck);
      newCheck.id = index;
      await newCheck.save();
      await addToCustomerBill(newCheck);
      await createCheckNotification(newCheck);
      resetCheckScreen(context);
      StaticMethods.showSnackBar(
        title: '??????????!',
        description: '?????? ???? ???? ???????????? ?????????? ????.',
        color: kLightGreenColor,
      );
    }
  }

  void updateCheck(BuildContext context, Check check) {}

  void resetCheckScreen(BuildContext context) {
    FocusScope.of(context).unfocus();
    checkNumberController.clear();
    checkAmountController.clear();
    checkDueDate = null;
    checkBankName.value = bankList[0].name!;
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
        await StaticMethods.selectDetails(
          title: '???????? ?????????? ???? ???? ???????????? ????????.',
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
            await StaticMethods.selectCustomer(
              title: typeOfCheck == TypeOfCheck.send
                  ? '???????????? ???? ???? ???????????? ????????'
                  : '?????????? ???? ???????????? ????????',
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
    var billBox = Hive.lazyBox<Bill>(billsBox);
    int key = billBox.keys.firstWhere((key) => key == checkCustomer!.id);
    Bill? newBill = await billBox.get(key);
    newBill!.check!.add(check);
    await newBill.save();
  }

  Future createCheckNotification(Check check) async {
    String amount = check.checkAmount!.abs().toString().seRagham();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: check.id!,
          channelKey: 'basic_channel',
          title: '${Emojis.money_dollar_banknote} ???? ???????? ????',
          body: '?????? ???? ???? ${typeOfCheck == TypeOfCheck.send ? '????' : '????'} '
              '${check.customerCheck!.name}'
              ' ???? ${check.checkBank!.name}'
              ' ???? ???????? $amount '
              '${Get.find<HomeController>().moneyUnit.value} ??????????.',
          notificationLayout: NotificationLayout.BigText,
          category: NotificationCategory.Reminder,
          displayOnBackground: true,
          wakeUpScreen: true,
          color: kBlueColor,
          payload: {'check_id': check.id.toString()}),
      schedule: NotificationCalendar.fromDate(
        date: check.checkDeliveryDate!,
        allowWhileIdle: true,
      ),
    );
  }
}

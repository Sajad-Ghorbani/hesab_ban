import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hesab_ban/constants.dart';
import 'package:hesab_ban/controllers/home_controller.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

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

  setDateOfCheck(BuildContext context, bool checkDeliverStatus) async {
    var settingsBox = Hive.lazyBox(settingBox);
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali.now(),
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
        checkDeliveryDateLabel.value =
            pickedDate.toJalaliDateTime().split(' ').first.toPersianDigit();
        checkDeliveryDate = pickedDate.toDateTime();
      } //
      else {
        checkDueDateLabel.value =
            pickedDate.toJalaliDateTime().split(' ').first.toPersianDigit();
        checkDueDate = pickedDate.toDateTime();
      }
    }
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
        StaticMethods.selectCustomer(
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
        StaticMethods.selectDetails(
          title: 'صادر کننده چک را انتخاب کنید.',
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
      await createCheckNotification(newCheck);
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
        await StaticMethods.selectDetails(
          title: 'صادر کننده چک را انتخاب کنید.',
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
          title: '${Emojis.money_dollar_banknote} سر رسید چک',
          body: 'شما یک چک ${typeOfCheck == TypeOfCheck.send ? 'به' : 'از'} '
              '${check.customerCheck!.name}'
              ' از بانک ${check.bankName}'
              ' به مبلغ $amount '
              '${Get.find<HomeController>().moneyUnit.value} دارید.',
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

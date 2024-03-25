import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/check_params.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/bank_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/delete_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/get_all_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/save_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/update_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/notification_service.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CheckController extends GetxController {
  final SaveCheckUseCase _saveCheckUseCase;
  final UpdateCheckUseCase _updateCheckUseCase;
  final DeleteCheckUseCase _deleteCheckUseCase;
  final GetAllCheckUseCase _getAllCheckUseCase;

  CheckController(
    this._saveCheckUseCase,
    this._updateCheckUseCase,
    this._getAllCheckUseCase,
    this._deleteCheckUseCase,
  );

  TextEditingController checkNumberController = TextEditingController();
  TextEditingController checkAmountController = TextEditingController();
  TextEditingController searchCustomerController = TextEditingController();
  late ScrollController checkScreenScrollController;

  RxBool showCheckFab = true.obs;

  String checkDueDateLabel = '-1';
  String checkDeliveryDateLabel = '-1';
  DateTime? checkDueDate;
  DateTime? checkDeliveryDate;

  String? typeOfCheck;
  CustomerEntity? checkCustomer;

  String? fromFactor;
  List<DropdownMenuItem<String>> bankLists = [];
  List<DropdownMenuItem<String>> customerLists = [];
  List<CustomerEntity> customers = [];
  List<CheckEntity> checks = [];
  List<BankEntity> banks = bankList..sort((a, b) => a.name!.compareTo(b.name!));

  String checkBankName = '';
  int? factorId;

  @override
  onInit() {
    super.onInit();
    checkBankName = banks[0].name!;
    checkScreenScrollController = ScrollController();
    init();
  }

  @override
  onClose() {
    super.onClose();
    checkNumberController.dispose();
    checkAmountController.dispose();
    checkScreenScrollController.dispose();
    searchCustomerController.dispose();
  }

  init() {
    getAllChecks();
    getAllCustomers();
    setBankList();
    setCustomerList();
  }

  initCreateScreen(CheckEntity? check) {
    Future.delayed(Duration.zero, () {
      init();
    });
    fromFactor = Get.parameters['from_factor'];
    if (check != null) {
      checkNumberController.text = check.checkNumber!;
      checkAmountController.text = check.checkAmount!.abs().formatPrice();
      checkDueDateLabel = check.checkDueDate.toString().toPersianDate();
      checkDeliveryDateLabel =
          check.checkDeliveryDate.toString().toPersianDate();
      checkDueDate = check.checkDueDate;
      checkDeliveryDate = check.checkDeliveryDate;
      typeOfCheck = check.typeOfCheck!.name;
      checkBankName = check.checkBank!.name!;
      checkCustomer = check.customerCheck;
      factorId = check.factorId;
    } //
    else {
      if (fromFactor != null) {
        setCheckDetailFromFactor();
      }
    }
  }

  getAllCustomers() {
    var response = Get.find<CustomerController>().getCustomers();
    if (response == null) {
      return;
    } //
    else {
      customers = response;
    }
    update();
  }

  setBankList() {
    bankLists.clear();
    for (var item in banks) {
      bankLists.add(
        DropdownMenuItem(
          value: item.name!,
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
        ),
      );
    }
    update();
  }

  setCheckDetailFromFactor() {
    typeOfCheck = Get.parameters['type_of_check']!;
    String customerId = Get.parameters['customer_id']!;
    if (Get.parameters['check_number'] != null) {
      checkBankName = Get.parameters['check_bank']!;
      checkNumberController.text = Get.parameters['check_number']!;
      checkAmountController.text = Get.parameters['check_amount']!;
      checkDueDateLabel = Get.parameters['check_due_date']!.toPersianDate();
      checkDueDate = DateTime.parse(Get.parameters['check_due_date']!);
      checkDeliveryDateLabel =
          Get.parameters['check_delivery_date']!.toPersianDate();
      checkDeliveryDate =
          DateTime.parse(Get.parameters['check_delivery_date']!);
    }
    for (var item in customers) {
      if (item.id == int.parse(customerId)) {
        checkCustomer = item;
      }
    }
  }

  setTypeOfCheck(bool isMe) {
    if (isMe) {
      typeOfCheck = 'send';
    } //
    else {
      typeOfCheck = 'received';
    }
    update();
  }

  setCustomerList() {
    List<DropdownMenuItem<String>> list = [];
    for (var item in customers) {
      list.add(
        DropdownMenuItem(
          value: item.name,
          child: Text(item.name!),
        ),
      );
    }
    customerLists = list;
    update();
  }

  void setCustomerCheck(String customerName) {
    for (var item in customers) {
      if (item.name == customerName) {
        checkCustomer = item;
      }
    }
    update();
  }

  setDateOfCheck(BuildContext context, bool checkDeliverStatus) async {
    FocusScope.of(context).unfocus();
    var pickedDate = await StaticMethods.getDate(context);
    if (pickedDate != null) {
      if (checkDeliverStatus) {
        checkDeliveryDateLabel = pickedDate.formatCompactDate();
        checkDeliveryDate = pickedDate.toDateTime();
      } //
      else {
        checkDueDateLabel = pickedDate.formatCompactDate();
        checkDueDate = pickedDate.toDateTime();
      }
      update();
    }
  }

  bool validateCheck() {
    String checkNumber = checkNumberController.text.trim();
    if (checkBankName == '-1' ||
        checkNumber.isEmpty ||
        checkAmountController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا فرم را کامل کنید.');
      return false;
    } //
    else if (checkDueDate == null || checkDeliveryDate == null) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'تاریخ چک را وارد کنید.');
      return false;
    } //
    else if (checkDueDate!.compareTo(checkDeliveryDate!) == 1) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description:
            'تاریخ های چک به درستی وارد نشده.\nتاریخ سررسید چک قبل از تاریخ تحویل چک می باشد.',
        duration: const Duration(seconds: 4),
      );
      return false;
    }
    return true;
  }

  Future<CheckEntity?> saveCheck(CheckParams checkParams) async {
    var response = await _saveCheckUseCase(checkParams);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    return response.data;
  }

  registerCheck() async {
    if (validateCheck()) {
      int amount = typeOfCheck == 'received'
          ? StaticMethods.removeSeparatorFromNumber(checkAmountController)
          : -StaticMethods.removeSeparatorFromNumber(checkAmountController);
      String checkNumber = checkNumberController.text.trim();
      CheckParams newCheck = CheckParams(
        checkNumber: checkNumber,
        checkAmount: amount,
        checkDueDate: checkDueDate,
        checkDeliveryDate: checkDeliveryDate,
        customerCheck: checkCustomer,
        typeOfCheck: typeOfCheck,
        checkBank: checkBankName,
      );
      if (fromFactor != null) {
        Get.back(result: newCheck);
        return;
      }
      var response = await saveCheck(newCheck);
      if (response != null) {
        await Get.find<BillController>()
            .addToBill(customer: newCheck.customerCheck!, check: response);
        await createCheckNotification(response, null);
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: 'ثبت چک با موفقیت انجام شد.',
          color: kLightGreenColor,
        );
        getAllChecks();
        update();
      }
    }
  }

  void updateCheck(CheckEntity check) async {
    if (validateCheck()) {
      int amount = typeOfCheck == 'received'
          ? StaticMethods.removeSeparatorFromNumber(checkAmountController)
          : -StaticMethods.removeSeparatorFromNumber(checkAmountController);
      String checkNumber = checkNumberController.text.trim();
      CheckParams newCheck = CheckParams(
        id: check.id,
        checkNumber: checkNumber,
        checkAmount: amount,
        checkDueDate: checkDueDate,
        checkDeliveryDate: checkDeliveryDate,
        customerCheck: check.customerCheck,
        typeOfCheck: typeOfCheck,
        checkBank: checkBankName,
        factorId: factorId,
      );
      var response = await _updateCheckUseCase(newCheck);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      } //
      else {
        await createCheckNotification(response.data!, check.id);
        await Get.find<BillController>()
            .updateBill(customer: check.customerCheck!, check: response.data!);
        Get.back();
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description: 'ویرایش چک با موفقیت انجام شد.',
          color: kLightGreenColor,
        );
        getAllChecks();
        update();
      }
    }
  }

  void resetCheckScreen(BuildContext context) {
    FocusScope.of(context).unfocus();
    checkNumberController.clear();
    checkAmountController.clear();
    checkDueDate = null;
    checkBankName = banks[0].name!;
    checkDueDateLabel = '-1';
    checkDeliveryDate = null;
    checkDeliveryDateLabel = '-1';
    checkCustomer = null;
    typeOfCheck = null;
    update();
  }

  Future createCheckNotification(CheckEntity check, int? id) async {
    final bool granted = await NotificationService().notificationStatus();
    if (!granted) {
      bool? status = await NotificationService().requestPermission();
      if (status != true) {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description:
              'شما دسترسی لازم برای ایجاد نوتیفیکیشن یادآوری چک ها را به حساب بان نداده اید.',
        );
      }
    } //
    else {
      String amount = check.checkAmount!.abs().formatPrice();
      int hours = Get.find<SettingController>().hoursNotification;
      int minutes = Get.find<SettingController>().minutesNotification;
      if (id != null) {
        await NotificationService().cancelNotification(id);
      }
      await NotificationService().scheduleNotification(
        id: check.id!,
        title: '💵 سر رسید چک',
        body: 'شما یک چک ${typeOfCheck == 'send' ? 'به' : 'از'} '
            '${check.customerCheck!.name}'
            ' از ${check.checkBank!.name}'
            ' به مبلغ $amount '
            '${Get.find<SettingController>().moneyUnit} دارید.',
        payload: '${check.id}',
        dateTime: DateTime(
          check.checkDeliveryDate!.year,
          check.checkDeliveryDate!.month,
          check.checkDeliveryDate!.day,
          hours,
          minutes,
        ),
      );
    }
  }

  List<CheckEntity>? getAllChecks() {
    var response = _getAllCheckUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      checks = response.data!;
      update();
      return checks;
    }
  }

  deleteCheck(int id) async {
    var response = await _deleteCheckUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      getAllChecks();
      await Get.find<BillController>().removeFromBill(
        customer: response.data!.customerCheck!,
        check: response.data,
      );
      update();
    }
  }
}

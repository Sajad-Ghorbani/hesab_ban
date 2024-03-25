import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/cash_params.dart';
import 'package:hesab_ban/app/core/utils/extensions.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/delete_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/get_all_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/save_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/update_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CashController extends GetxController {
  final SaveCashUseCase _saveCashUseCase;
  final UpdateCashUseCase _updateCashUseCase;
  final GetAllCashUseCase _getAllCashUseCase;
  final DeleteCashUseCase _deleteCashUseCase;

  CashController(
    this._saveCashUseCase,
    this._updateCashUseCase,
    this._getAllCashUseCase,
    this._deleteCashUseCase,
  );

  TextEditingController searchCustomerController = TextEditingController();
  TextEditingController cashAmountController = TextEditingController();
  late ScrollController cashScreenScrollController;

  RxBool showCashFab = true.obs;
  int? factorId;

  String cashDateLabel = '-1';
  DateTime? cashDate;

  String? typeOfCash;
  CustomerEntity? cashCustomer;

  String? fromFactor;
  List<DropdownMenuItem<String>> customerLists = [];
  List<CustomerEntity> customers = [];
  List<CashEntity> cashes = [];

  @override
  onInit() {
    super.onInit();
    cashScreenScrollController = ScrollController();
    getAllCashes();
  }

  @override
  onClose() {
    super.onClose();
    cashScreenScrollController.dispose();
  }

  init(CashEntity? cash) async {
    await Future.delayed(Duration.zero, () {
      getAllCustomers();
      setCustomerList();
    });
    fromFactor = Get.parameters['from_factor'];
    if (fromFactor != null) {
      typeOfCash = Get.parameters['type_of_cash']!;
      String customerId = Get.parameters['customer_id']!;
      cashAmountController.text = Get.parameters['cash_amount'] ?? '';
      cashDateLabel = Get.parameters['cash_date'] != null
          ? Get.parameters['cash_date']!.toPersianDate()
          : '-1';
      cashDate = Get.parameters['cash_date'] != null
          ? DateTime.parse(Get.parameters['cash_date']!)
          : null;
      for (var item in customers) {
        if (item.id == int.parse(customerId)) {
          cashCustomer = item;
        }
      }
    }
    if (cash != null) {
      cashAmountController.text = cash.cashAmount!.abs().formatPrice();
      cashDateLabel = cash.cashDate.toString().toPersianDate();
      typeOfCash = cash.cashAmount! < 0 ? 'send' : 'received';
      cashCustomer = cash.customer;
      cashDate = cash.cashDate;
      factorId = cash.factorId;
    }
  }

  List<CashEntity>? getAllCashes() {
    var response = _getAllCashUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      cashes = response.data!;
      update();
      return cashes;
    }
  }

  Future<CashEntity?> registerCash(CashParams cashParams) async {
    var response = await _saveCashUseCase(cashParams);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    return response.data;
  }

  bool validateCashForm() {
    if (cashCustomer == null) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description:
            '${typeOfCash == 'send' ? 'دریافت کننده' : 'پرداخت کننده'} نباید خالی باشد. لطفا مقدار را انتخاب کنید',
      );
      return false;
    } //
    else if (cashAmountController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'مبلغ نباید خالی باشد. لطفا مبلغ را وارد کنید.',
      );
      return false;
    } //
    else if (cashDate == null) {
      StaticMethods.showSnackBar(
        title: 'خطا',
        description: 'تاریخ نباید خالی باشد. لطفا تاریخ را انتخاب کنید.',
      );
      return false;
    }
    return true;
  }

  Future saveCash() async {
    if (validateCashForm()) {
      int amount = typeOfCash == 'received'
          ? StaticMethods.removeSeparatorFromNumber(cashAmountController)
          : -StaticMethods.removeSeparatorFromNumber(cashAmountController);
      CashParams cashParams = CashParams(
        cashCustomer: cashCustomer,
        cashAmount: amount,
        cashDate: cashDate,
        factorId: factorId,
      );
      if (fromFactor != null) {
        Get.back(result: cashParams);
        return null;
      }
      var response = await registerCash(cashParams);
      if (response != null) {
        getAllCashes();
        Get.find<BillController>().addToBill(
          customer: cashParams.cashCustomer!,
          cash: response,
        );
        StaticMethods.showSnackBar(
          title: 'تبریک!',
          description:
              '${typeOfCash == 'send' ? 'پرداخت' : 'دریافت'} وجه نقد با موفقیت انجام شد.',
          color: kLightGreenColor,
        );
      }
    }
  }

  Future<bool> updateCash(
      {required int id, required BuildContext context}) async {
    if (validateCashForm()) {
      int amount = typeOfCash == 'received'
          ? StaticMethods.removeSeparatorFromNumber(cashAmountController)
          : -StaticMethods.removeSeparatorFromNumber(cashAmountController);
      CashParams cashParams = CashParams(
        id: id,
        cashCustomer: cashCustomer,
        cashAmount: amount,
        cashDate: cashDate,
        factorId: factorId,
      );
      var response = await _updateCashUseCase(cashParams);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
        return false;
      } //
      else {
        getAllCashes();
        Get.find<BillController>().updateBill(
          customer: cashParams.cashCustomer!,
          cash: response.data,
        );
        Get.back();
        return true;
      }
    }
    return false;
  }

  void deleteCash(int id) async {
    var response = await _deleteCashUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return;
    } //
    else {
      getAllCashes();
      Get.find<BillController>().removeFromBill(
          customer: response.data!.customer!, cash: response.data!);
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

  void setTypeOfCash(bool isMe) {
    if (isMe) {
      typeOfCash = 'send';
    } //
    else {
      typeOfCash = 'received';
    }
    update();
  }

  void setDateOfCash(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var pickedDate = await StaticMethods.getDate(context);
    if (pickedDate != null) {
      cashDateLabel = pickedDate.formatCompactDate();
      cashDate = pickedDate.toDateTime();
      update();
    }
  }

  void setCustomerCash(String customerName) {
    for (var item in customers) {
      if (item.name == customerName) {
        cashCustomer = item;
      }
    }
    update();
  }

  void resetCashScreen(BuildContext context) {
    FocusScope.of(context).unfocus();
    searchCustomerController.clear();
    cashAmountController.clear();
    cashCustomer = null;
    cashDateLabel = '-1';
    update();
  }
}

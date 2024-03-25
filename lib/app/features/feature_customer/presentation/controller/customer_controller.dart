import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/core/params/customer_params.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/delete_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/get_all_customers_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/get_customer_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/save_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/update_customer_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CustomerController extends GetxController {
  final SaveCustomerUseCase _saveCustomerUseCase;
  final UpdateCustomerUseCase _updateCustomerUseCase;
  final DeleteCustomerUseCase _deleteCustomerUseCase;
  final GetAllCustomersUseCase _getAllCustomersUseCase;
  final GetCustomerByIdUseCase _getCustomerByIdUseCase;

  CustomerController(
    this._saveCustomerUseCase,
    this._updateCustomerUseCase,
    this._getAllCustomersUseCase,
    this._deleteCustomerUseCase,
    this._getCustomerByIdUseCase,
  );

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerPhone2Controller = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerBalanceController = TextEditingController();
  TextEditingController customerDescriptionController = TextEditingController();

  RxBool showCustomersFab = true.obs;
  RxBool customerIsDebtor = true.obs;
  late ScrollController customerScreenScrollController;

  List<CustomerEntity> customers = [];
  List<CustomerEntity> customersFiltered = [];

  @override
  void onInit() {
    super.onInit();
    customerScreenScrollController = ScrollController();
    getCustomers();
  }

  @override
  void onClose() {
    super.onClose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerPhone2Controller.dispose();
    customerAddressController.dispose();
    customerBalanceController.dispose();
    customerDescriptionController.dispose();
    customerScreenScrollController.dispose();
  }

  List<CustomerEntity>? getCustomers() {
    var response = _getAllCustomersUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      customers = response.data!;
      update();
      return customers;
    }
  }

  CustomerEntity? getCustomerById(int id) {
    var response = _getCustomerByIdUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    }
    return response.data;
  }

  void saveCustomer(context) async {
    if (customerNameController.text.trim().isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else if (customerPhoneController.text.trim().isNotEmpty &&
            !customerPhoneController.text.trim().isValidIranianMobileNumber() ||
        customerPhone2Controller.text.trim().isNotEmpty &&
            !customerPhone2Controller.text
                .trim()
                .isValidIranianMobileNumber()) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'فرمت شماره تماس وارد شده صحیح نمی باشد.');
    } //
    else {
      CustomerParams newCustomer = CustomerParams(
        name: customerNameController.text.trim(),
        phoneNumber1: customerPhoneController.text.trim(),
        phoneNumber2: customerPhone2Controller.text.trim(),
        address: customerAddressController.text.trim(),
        initialAccountBalance: customerBalanceController.text.trim().isEmpty
            ? 0
            : customerIsDebtor.value
                ? -StaticMethods.removeSeparatorFromNumber(
                    customerBalanceController)
                : StaticMethods.removeSeparatorFromNumber(
                    customerBalanceController,
                  ),
        description: customerDescriptionController.text.trim(),
      );
      var response = await _saveCustomerUseCase(newCustomer);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: response.error!,
        );
        return;
      } //
      else {
        StaticMethods.showSnackBar(
          title: 'تبریک',
          description: 'کاربر ${response.data!.name} با موفقیت ثبت شد.',
          color: kLightGreenColor,
        );
        await Get.find<BillController>().saveBill(response.data!);
        getCustomers();
        setCustomerList(Get.parameters['type']);
      }
      resetCustomerScreen(context);
    }
    update();
  }

  void updateCustomer(context, int id) async {
    if (customerNameController.text.isEmpty) {
      StaticMethods.showSnackBar(
          title: 'خطا', description: 'لطفا نام را وارد کنید.');
    } //
    else {
      CustomerParams newCustomer = CustomerParams(
        id: id,
        name: customerNameController.text.trim(),
        phoneNumber1: customerPhoneController.text.trim(),
        phoneNumber2: customerPhone2Controller.text.trim(),
        address: customerAddressController.text.trim(),
        initialAccountBalance: customerBalanceController.text.trim().isEmpty
            ? 0
            : customerIsDebtor.value
                ? -StaticMethods.removeSeparatorFromNumber(
                    customerBalanceController)
                : StaticMethods.removeSeparatorFromNumber(
                    customerBalanceController,
                  ),
        description: customerDescriptionController.text.trim(),
      );
      var response = await _updateCustomerUseCase(newCustomer);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا',
          description: response.error!,
        );
      } //
      else {
        await Get.find<BillController>().updateBill(customer: response.data!);
        Get.back();
        StaticMethods.showSnackBar(
          title: 'تبریک',
          description: 'کاربر ${response.data!.name} با موفقیت ویرایش شد.',
          color: kLightGreenColor,
        );
        resetCustomerScreen(context);
        getCustomers();
        setCustomerList(Get.parameters['type']);
      }
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
    customerDescriptionController.clear();
    customerIsDebtor.value = true;
  }

  void deleteCustomer(int id) async {
    var response = await _deleteCustomerUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    } //
    else {
      StaticMethods.showSnackBar(
        title: 'تبریک',
        description: 'کاربر ${response.data} با موفقیت حذف شد.',
        color: kLightGreenColor,
      );
      getCustomers();
      setCustomerList(Get.parameters['type']);
      update();
    }
  }

  setCustomerList(String? type) {
    if (type != null && type.isNotEmpty) {
      if (type == Constants.debtorType) {
        customersFiltered = customers.where((element) {
          BillEntity? entity =
              Get.find<BillController>().getBillById(element.id!);
          return entity!.cashPayment! < 0;
        }).toList();
      } //
      else {
        customersFiltered = customers.where((element) {
          BillEntity? entity =
              Get.find<BillController>().getBillById(element.id!);
          return entity!.cashPayment! >= 0;
        }).toList();
      }
    } //
    else {
      customersFiltered = customers;
    }
    update();
  }
}

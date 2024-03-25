import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/core/params/bill_params.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/add_to_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/delete_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/get_all_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/get_bill_by_id.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/remove_from_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/save_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_cash_of_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_check_of_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_customer_bill.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_factor_of_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/entities/cash_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';
import 'package:hesab_ban/app/features/feature_print/presentation/controller/print_controller.dart';

class BillController extends GetxController {
  final SaveBillUseCase _saveBillUseCase;
  final DeleteBillUseCase _deleteBillUseCase;
  final UpdateCustomerBillUseCase _updateCustomerUseCase;
  final UpdateFactorOfBillUseCase _updateFactorOfBillUseCase;
  final UpdateCashOfBillUseCase _updateCashOfBillUseCase;
  final UpdateCheckOfBillUseCase _updateCheckOfBillUseCase;
  final GetAllBillUseCase _getAllBillUseCase;
  final GetBillByIdUseCase _getBillByIdUseCase;
  final AddToBillUseCase _addToBillUseCase;
  final RemoveFromBillUseCase _removeFromBillUseCase;

  BillController(
    this._saveBillUseCase,
    this._deleteBillUseCase,
    this._updateFactorOfBillUseCase,
    this._getAllBillUseCase,
    this._updateCashOfBillUseCase,
    this._updateCheckOfBillUseCase,
    this._getBillByIdUseCase,
    this._addToBillUseCase,
    this._removeFromBillUseCase,
    this._updateCustomerUseCase,
  );

  late ScrollController scrollController;
  RxBool showFab = false.obs;
  CustomerEntity? customer;
  BillEntity? billEntity;

  @override
  onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  getCustomer(int id) {
    var response = Get.find<CustomerController>().getCustomerById(id);
    if (response != null) {
      customer = response;
    }
    update();
  }

  List<BillEntity>? getAllBills() {
    var response = _getAllBillUseCase();
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    } //
    else {
      return response.data!;
    }
  }

  BillEntity? getBillById(int id) {
    var response = _getBillByIdUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
      return null;
    }
    billEntity = response.data;
    // update();
    return billEntity;
  }

  Future<void> saveBill(CustomerEntity customer) async {
    BillParams billParams = BillParams(
      customer: customer,
    );
    var response = await _saveBillUseCase(billParams);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
  }

  Future<void> addToBill(
      {required CustomerEntity customer,
      FactorEntity? factor,
      CheckEntity? check,
      CashEntity? cash}) async {
    BillParams billParams = BillParams(
      customer: customer,
      factor: factor,
      check: check,
      cash: cash,
    );
    var response = await _addToBillUseCase(billParams);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
  }

  Future<void> updateBill({
    required CustomerEntity customer,
    FactorEntity? factor,
    CheckEntity? check,
    CashEntity? cash,
  }) async {
    BillParams billParams = BillParams(
      customer: customer,
      factor: factor,
      cash: cash,
      check: check,
    );
    if (factor != null) {
      var response = await _updateFactorOfBillUseCase(billParams);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      }
    }
    if (check != null) {
      var response = await _updateCheckOfBillUseCase(billParams);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      }
    }
    if (cash != null) {
      var response = await _updateCashOfBillUseCase(billParams);
      if (response.data == null) {
        StaticMethods.showSnackBar(
          title: 'خطا!',
          description: response.error!,
        );
      }
    }
    var response = await _updateCustomerUseCase(billParams);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    getAllBills();
  }

  Future<void> deleteBill(int id) async {
    var response = await _deleteBillUseCase(id);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
  }

  Future<void> removeFromBill({
    required CustomerEntity customer,
    FactorEntity? factor,
    CheckEntity? check,
    CashEntity? cash,
  }) async {
    BillParams billParams = BillParams(
      customer: customer,
      factor: factor,
      check: check,
      cash: cash,
    );
    var response = await _removeFromBillUseCase(billParams);
    if (response.data == null) {
      StaticMethods.showSnackBar(
        title: 'خطا!',
        description: response.error!,
      );
    }
    getAllBills();
    update();
  }

  saveFactor(FactorEntity factor) async {
    String storeName = Get.find<SettingController>().storeName;
    String storeAddress = Get.find<SettingController>().storeAddress;
    if (storeName == '' || storeAddress == '') {
      StaticMethods.showSnackBar(
        title: 'توجه',
        description:
            'برای مشاهده و ارسال فاکتور اطلاعات فروشگاه در تنظیمات برنامه را تکمیل کنید.',
      );
    } //
    else {
      return await Get.find<PrintController>()
          .generate(factor, billEntity!.cashPayment!);
    }
  }
}

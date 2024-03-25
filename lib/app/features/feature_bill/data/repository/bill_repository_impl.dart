import 'package:flutter/material.dart';
import 'package:hesab_ban/app/core/params/bill_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_bill/data/data_source/local/bill_db.dart';
import 'package:hesab_ban/app/features/feature_bill/data/models/bill_model.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/entities/bill_entity.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';

class BillRepositoryImpl extends BillRepository {
  final BillDB _billDB;

  BillRepositoryImpl(this._billDB);

  @override
  Future<DataState<String>> deleteBill(int id) async {
    try {
      Bill? bill = _billDB.getById(id);
      await bill!.delete();
      return DataSuccess(bill.customer!.name);
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed('خطایی در حذف حساب مشتری به وجود آمده است.');
    }
  }

  @override
  DataState<List<BillEntity>> getAllBills() {
    try {
      List<Bill> bills = _billDB.getAll();
      return DataSuccess(bills.map((e) => e.toEntity()).toList());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در دریافت حسابهای مشتریان به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> saveBill(BillEntity billEntity) async {
    try {
      Bill bill = Bill.fromEntity(billEntity);
      return DataSuccess((await _billDB.save(bill)).toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed('خطایی در ثبت حساب مشتری به وجود آمده است.');
    }
  }

  @override
  DataState<BillEntity?> getBillById(int id) {
    try {
      Bill? bill = _billDB.getById(id);
      return DataSuccess(bill!.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در دریافت اطلاعات حساب مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> removeFromBill(BillParams billParams) async {
    try {
      Bill bill = await _billDB.deleteFromBill(billParams);
      return DataSuccess(bill.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در بروزرسانی حساب مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> addToBill(BillParams billParams) async {
    try {
      Bill bill = await _billDB.addToBill(billParams);
      return DataSuccess(bill.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در بروزرسانی حساب مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> updateCashOfBill(BillParams billParams) async {
    try {
      Bill bill = await _billDB.updateCash(billParams);
      return DataSuccess(bill.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در بروزرسانی حساب مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> updateCheckOfBill(BillParams billParams) async {
    try {
      Bill bill = await _billDB.updateCheck(billParams);
      return DataSuccess(bill.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در بروزرسانی حساب مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> updateFactorOfBill(
      BillParams billParams) async {
    try {
      Bill bill = await _billDB.updateFactor(billParams);
      return DataSuccess(bill.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در بروزرسانی حساب مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<BillEntity>> updateCustomerBill(
      BillParams billParams) async {
    try {
      Bill bill = await _billDB
          .updateCustomer(Customer.fromEntity(billParams.customer!));
      return DataSuccess(bill.toEntity());
    } //
    on Exception catch (e) {
      debugPrint(e.toString());
      return const DataFailed(
          'خطایی در بروزرسانی حساب مشتری به وجود آمده است.');
    }
  }
}

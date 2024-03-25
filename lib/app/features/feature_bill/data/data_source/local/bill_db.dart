import 'package:hesab_ban/app/core/params/bill_params.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_bill/data/models/bill_model.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hive/hive.dart';

class BillDB {
  final _billBox = Hive.box<Bill>(Constants.billsBox);

  getCashPayment(Bill bill) {
    int cashPayment = bill.customer!.initialAccountBalance ?? 0;
    if (bill.factor != null) {
      for (var item in bill.factor!) {
        cashPayment = cashPayment + item.factorSum!;
      }
    }
    if (bill.check != null) {
      for (var item in bill.check!) {
        cashPayment = cashPayment + item.checkAmount!;
      }
    }
    if (bill.cash != null) {
      for (var item in bill.cash!) {
        cashPayment = cashPayment + item.cashAmount!;
      }
    }
    bill.cashPayment = cashPayment;
  }

  Future<void> delete(int id) async {
    await _billBox.delete(id);
  }

  List<Bill> getAll() {
    return _billBox.values.toList();
  }

  Bill? getById(int id) {
    return _billBox.get(id);
  }

  Future<Bill> save(Bill value) async {
    final int key = await _billBox.add(value);
    value.id = key;
    await value.save();
    return value;
  }

  Future<Bill> updateCustomer(Customer customer) async {
    Bill? bill = _billBox.get(customer.id);
    bill!.customer = customer;
    getCashPayment(bill);
    await bill.save();
    return bill;
  }

  Future<Bill> updateFactor(BillParams value) async {
    Bill bill = _billBox.get(value.customer!.id) ?? Bill();
    Factor factor =
        bill.factor!.firstWhere((element) => element.id == value.factor!.id);
    int factorIndex = bill.factor!.indexOf(factor);
    bill.factor!.removeAt(factorIndex);
    bill.factor!.insert(factorIndex, Factor.fromEntity(value.factor!));
    getCashPayment(bill);
    await bill.save();
    return bill;
  }

  Future<Bill> updateCheck(BillParams value) async {
    Bill bill = _billBox.get(value.customer!.id) ?? Bill();
    Check check =
        bill.check!.firstWhere((element) => element.id == value.check!.id);
    int checkIndex = bill.check!.indexOf(check);
    bill.check!.removeAt(checkIndex);
    bill.check!.insert(checkIndex, Check.fromEntity(value.check!));
    getCashPayment(bill);
    await bill.save();
    return bill;
  }

  Future<Bill> updateCash(BillParams value) async {
    Bill bill = _billBox.get(value.customer!.id) ?? Bill();
    Cash cash =
        bill.cash!.firstWhere((element) => element.id == value.cash!.id);
    int cashIndex = bill.cash!.indexOf(cash);
    bill.cash!.removeAt(cashIndex);
    bill.cash!.insert(cashIndex, Cash.fromEntity(value.cash!));
    getCashPayment(bill);
    await bill.save();
    return bill;
  }

  Future<Bill> addToBill(BillParams value) async {
    Bill bill = _billBox.get(value.customer!.id) ?? Bill();
    if (value.factor != null) {
      bill.factor!.add(Factor.fromEntity(value.factor!));
    }
    if (value.check != null) {
      bill.check!.add(Check.fromEntity(value.check!));
    }
    if (value.cash != null) {
      bill.cash!.add(Cash.fromEntity(value.cash!));
    }
    getCashPayment(bill);
    await bill.save();
    return bill;
  }

  Future<Bill> deleteFromBill(BillParams value) async {
    Bill bill = _billBox.get(value.customer!.id) ?? Bill();
    if (value.factor != null) {
      bill.factor!.removeWhere((element) => element.id == value.factor!.id);
    }
    if (value.check != null) {
      bill.check!.removeWhere((element) => element.id == value.check!.id);
    }
    if (value.cash != null) {
      bill.cash!.removeWhere((element) => element.id == value.cash!.id);
    }
    getCashPayment(bill);
    await bill.save();
    return bill;
  }
}

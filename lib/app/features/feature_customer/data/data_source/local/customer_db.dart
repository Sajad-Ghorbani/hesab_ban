import 'package:get/get.dart';
import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/data_source/local/factor_db.dart';
import 'package:hive/hive.dart';

class CustomerDB extends DBHelper<Customer> {
  final _customerBox = Hive.box<Customer>(Constants.customersBox);

  @override
  Future<void> save(Customer value) async {
    final int key = await _customerBox.add(value);
    value.id = key;
    await value.save();
  }

  @override
  Future<void> update(Customer value) async {
    await _customerBox.put(value.id, value);
  }

  @override
  Future<void> delete(int id) async {
    Customer? customer = getById(id);
    if (customer != null) {
      customer.isActive = false;
      customer.save();
      //
      final factors = Get.find<FactorDB>().getAll();
      await Future.forEach(factors, (factor) async {
        if (factor.customer?.id == id) {
          factor.customer!.isActive = false;
          await factor.save();
        }
      });
    }
  }

  @override
  Customer? getById(int id) {
    return _customerBox.get(id);
  }

  @override
  List<Customer> getAll() {
    setIsActiveForOldCustomers();
    return _customerBox.values
        .where((customer) => customer.isActive != false)
        .toList();
  }

  Future<({bool status, String name, bool isOne})> existPhoneNumber(
      Customer customer) async {
    bool data = false;
    bool data2 = false;
    String customerName1 = '';
    String customerName2 = '';
    if (customer.phoneNumber1!.isNotEmpty) {
      data = _customerBox.values.any((element) {
        if (element.phoneNumber1 == customer.phoneNumber1 ||
            element.phoneNumber2 == customer.phoneNumber1) {
          customerName1 = element.name!;
          return true;
        }
        return false;
      });
    } //
    if (customer.phoneNumber2!.isNotEmpty) {
      data2 = _customerBox.values.any((element) {
        if (element.phoneNumber1 == customer.phoneNumber2 ||
            element.phoneNumber2 == customer.phoneNumber2) {
          customerName2 = element.name!;
          return true;
        }
        return false;
      });
    }
    return data
        ? (status: data, name: customerName1, isOne: true)
        : (status: data2, name: customerName2, isOne: false);
  }

  // This method is for update customer that isActivate is null in old version
  setIsActiveForOldCustomers() async {
    List<Customer> customers = _customerBox.values
        .where((customer) => customer.isActive == null)
        .toList();
    for (var customer in customers) {
      customer.isActive ??= true;
      await customer.save();
    }
  }
}

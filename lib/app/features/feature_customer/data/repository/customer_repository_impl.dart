import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_customer/data/data_source/local/customer_db.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository {
  final CustomerDB _customerDB;

  CustomerRepositoryImpl(this._customerDB);

  @override
  Future<DataState<CustomerEntity>> saveCustomer(
      CustomerEntity customerEntity) async {
    try {
      Customer customer = Customer.fromEntity(customerEntity);
      ({bool status, String name, bool isOne}) existCustomer =
          await _customerDB.existPhoneNumber(customer);
      if (existCustomer.status) {
        return DataFailed(
            'شماره تماس ${existCustomer.isOne ? 1 : 2} قبلا برای ${existCustomer.name} ثبت شده است.');
      }
      await _customerDB.save(customer);
      return DataSuccess(customer.toEntity());
    } //
    catch (e) {
      return const DataFailed('خطایی در ثبت مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<String>> deleteCustomer(int id) async {
    try {
      var response = getCustomerById(id);
      CustomerEntity customerEntity = response.data!;
      await _customerDB.delete(id);
      return DataSuccess(customerEntity.name);
    } //
    catch (e) {
      return const DataFailed('خطایی در پاک کردن مشتری به وجود آمده است.');
    }
  }

  @override
  DataState<List<CustomerEntity>> getAllCustomers() {
    try {
      List<Customer> customers = _customerDB.getAll();
      List<CustomerEntity> customersEntity = [];
      for (var value in customers) {
        customersEntity.add(value.toEntity());
      }
      return DataSuccess(customersEntity);
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات مشتریان به وجود آمده است.');
    }
  }

  @override
  DataState<CustomerEntity?> getCustomerById(int id) {
    try {
      var customer = _customerDB.getById(id);
      return DataSuccess(customer?.toEntity());
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در دریافت اطلاعات مشتری به وجود آمده است.');
    }
  }

  @override
  Future<DataState<CustomerEntity>> updateCustomer(
      CustomerEntity customerEntity) async {
    try {
      Customer customer = Customer.fromEntity(customerEntity);
      await _customerDB.update(customer);
      return DataSuccess(customerEntity);
    } //
    catch (e) {
      return const DataFailed(
          'خطایی در بروزرسانی اطلاعات مشتری به وجود آمده است.');
    }
  }
}

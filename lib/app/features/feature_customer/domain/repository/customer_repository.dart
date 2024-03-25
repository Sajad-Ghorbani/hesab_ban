import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<DataState<CustomerEntity>> saveCustomer(CustomerEntity customerEntity);

  Future<DataState<CustomerEntity>> updateCustomer(
      CustomerEntity customerEntity);

  Future<DataState<String>> deleteCustomer(int id);

  DataState<CustomerEntity?> getCustomerById(int id);

  DataState<List<CustomerEntity>> getAllCustomers();
}

import 'package:hesab_ban/app/core/params/customer_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';

class SaveCustomerUseCase
    extends AsyncUseCase<DataState<CustomerEntity>, CustomerParams> {
  final CustomerRepository _customerRepository;

  SaveCustomerUseCase(this._customerRepository);

  @override
  Future<DataState<CustomerEntity>> call(CustomerParams params) {
    CustomerEntity customer = CustomerEntity(
      name: params.name,
      address: params.address,
      phoneNumber1: params.phoneNumber1,
      phoneNumber2: params.phoneNumber2,
      description: params.description,
      initialAccountBalance: params.initialAccountBalance,
      isActive: true,
    );
    return _customerRepository.saveCustomer(customer);
  }
}

import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';

class DeleteCustomerUseCase extends AsyncUseCase<DataState<String>,int>{
  final CustomerRepository _customerRepository;

  DeleteCustomerUseCase(this._customerRepository);

  @override
  Future<DataState<String>> call(int params) {
    return _customerRepository.deleteCustomer(params);
  }

}
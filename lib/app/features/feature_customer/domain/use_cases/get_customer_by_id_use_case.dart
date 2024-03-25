import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';

class GetCustomerByIdUseCase extends InputUseCase<DataState<CustomerEntity?>,int>{
  final CustomerRepository _customerRepository;

  GetCustomerByIdUseCase(this._customerRepository);

  @override
  DataState<CustomerEntity?> call(int params) {
    return _customerRepository.getCustomerById(params);
  }
}

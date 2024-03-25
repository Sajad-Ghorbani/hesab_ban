import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';

class GetAllCustomersUseCase extends UseCase<DataState<List<CustomerEntity>>>{
  final CustomerRepository _customerRepository;

  GetAllCustomersUseCase(this._customerRepository);

  @override
  DataState<List<CustomerEntity>> call() {
    return _customerRepository.getAllCustomers();
  }

}
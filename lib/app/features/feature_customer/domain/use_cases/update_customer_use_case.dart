import 'package:hesab_ban/app/core/params/customer_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/entities/customer_entity.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';

class UpdateCustomerUseCase
    extends AsyncUseCase<DataState<CustomerEntity>, CustomerParams> {
  final CustomerRepository _customerRepository;
  final FactorRepository _factorRepository;

  UpdateCustomerUseCase(this._customerRepository, this._factorRepository);

  @override
  Future<DataState<CustomerEntity>> call(CustomerParams params) async {
    CustomerEntity customer = CustomerEntity(
      id: params.id,
      name: params.name,
      address: params.address,
      phoneNumber1: params.phoneNumber1,
      phoneNumber2: params.phoneNumber2,
      description: params.description,
      initialAccountBalance: params.initialAccountBalance,
      isActive: true,
    );
    Future.forEach(_factorRepository.getAllFactors().data!, (item) async{
      if (item.customer!.id == params.id) {
        await _factorRepository.updateFactor(
          FactorEntity(
            id: item.id,
            customer: customer,
          ),
        );
      }
    });
    return _customerRepository.updateCustomer(customer);
  }
}

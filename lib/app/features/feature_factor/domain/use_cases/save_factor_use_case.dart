import 'package:hesab_ban/app/core/params/factor_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';

class SaveFactorUseCase extends AsyncUseCase<DataState<FactorEntity>, FactorParams> {
  final FactorRepository _factorRepository;

  SaveFactorUseCase(this._factorRepository);

  @override
  Future<DataState<FactorEntity>> call(FactorParams params) async {
    TypeOfFactor typeOfFactor = TypeOfFactor.values
        .firstWhere((element) => element.name == params.typeOfFactor);
    return _factorRepository.saveFactor(
      FactorEntity(
        customer: params.customer,
        factorDate: params.factorDate,
        factorSum: params.factorSum,
        typeOfFactor: typeOfFactor,
        factorRows: params.factorRows,
        cashesId: params.cashesId,
        checksId: params.checksId,
        tax: params.tax,
        offer: params.offer,
        costs: params.costs,
        description: params.description,
      ),
    );
  }
}

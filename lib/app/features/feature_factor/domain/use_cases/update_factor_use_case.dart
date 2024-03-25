import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';

class UpdateFactorUseCase extends AsyncUseCase<DataState<FactorEntity>,FactorEntity>{
  final FactorRepository _factorRepository;

  UpdateFactorUseCase(this._factorRepository);

  @override
  Future<DataState<FactorEntity>> call(FactorEntity params) {
    return _factorRepository.updateFactor(params);
  }
}
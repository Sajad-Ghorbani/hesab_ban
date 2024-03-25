import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';

class DeleteFactorUseCase {
  final FactorRepository _factorRepository;

  DeleteFactorUseCase(this._factorRepository);

  DataState<String> call(int params) {
    return _factorRepository.deleteFactor(params);
  }
}
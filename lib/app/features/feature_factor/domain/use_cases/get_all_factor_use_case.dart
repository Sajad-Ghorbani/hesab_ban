import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/entities/factor_entity.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';

class GetAllFactorUseCase extends UseCase<DataState<List<FactorEntity>>> {
  final FactorRepository _factorRepository;

  GetAllFactorUseCase(this._factorRepository);

  @override
  DataState<List<FactorEntity>> call() {
    return _factorRepository.getAllFactors();
  }
}

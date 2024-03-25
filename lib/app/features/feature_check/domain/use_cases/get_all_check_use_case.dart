import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/repository/check_repository.dart';

class GetAllCheckUseCase extends UseCase<DataState<List<CheckEntity>>> {
  final CheckRepository _checkRepository;

  GetAllCheckUseCase(this._checkRepository);

  @override
  DataState<List<CheckEntity>> call() {
    return _checkRepository.getAllCheck();
  }
}

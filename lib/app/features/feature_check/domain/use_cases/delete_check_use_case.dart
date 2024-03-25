import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/entities/check_entity.dart';
import 'package:hesab_ban/app/features/feature_check/domain/repository/check_repository.dart';

class DeleteCheckUseCase extends AsyncUseCase<DataState<CheckEntity>, int> {
  final CheckRepository _checkRepository;

  DeleteCheckUseCase(this._checkRepository);

  @override
  Future<DataState<CheckEntity>> call(int params) {
    return _checkRepository.deleteCheck(params);
  }
}

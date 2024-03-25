import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/user_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/user_repository.dart';

class GetUserByIdUseCase extends AsyncUseCase<DataState<UserEntity?>,int>{
  final UserRepository _userRepository;

  GetUserByIdUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity?>> call(int params)async {
    return _userRepository.getById(params);
  }
}
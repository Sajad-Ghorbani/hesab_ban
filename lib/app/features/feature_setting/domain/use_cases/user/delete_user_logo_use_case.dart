import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/user_repository.dart';

class DeleteUserLogoUseCase extends AsyncUseCase<DataState<String>,int>{
  final UserRepository _userRepository;

  DeleteUserLogoUseCase(this._userRepository);

  @override
  Future<DataState<String>> call(int params) async{
    return await _userRepository.deleteUserLogo(params);
  }
}
import 'package:hesab_ban/app/core/params/user_params.dart';
import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/user_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/user_repository.dart';

class SaveUserUseCase extends AsyncUseCase<DataState<UserEntity>, UserParams> {
  final UserRepository _userRepository;

  SaveUserUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> call(UserParams params) async {
    return _userRepository.save(
      UserEntity(
        name: params.name,
        phoneNumber: params.phoneNumber,
        storeLogo: params.storeLogo,
        storeName: params.storeName,
        storeAddress: params.storeAddress,
      ),
    );
  }
}

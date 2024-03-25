import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/user_entity.dart';

abstract class UserRepository{
  Future<DataState<UserEntity>> save(UserEntity userEntity);

  Future<DataState<UserEntity>> update(UserEntity userEntity);

  Future<DataState<UserEntity?>> getById(int id);

  Future<DataState<String>> deleteUserLogo(int id);

}
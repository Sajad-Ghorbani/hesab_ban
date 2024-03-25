import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_setting/data/data_source/local/user_db.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/user_model.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/user_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDB _userDB;

  UserRepositoryImpl(this._userDB);

  @override
  Future<DataState<UserEntity?>> getById(int id) async {
    try {
      var response = _userDB.getById(id);
      return DataSuccess(response!.toEntity());
    } catch (_) {
      return const DataFailed('مشکلی در دریافت اطلاعات کاربر رخ داده است.');
    }
  }

  @override
  Future<DataState<UserEntity>> save(UserEntity userEntity) async {
    try {
      User user = User.fromEntity(userEntity);
      await _userDB.save(user);
      return DataSuccess(user.toEntity());
    } on Exception catch (_) {
      return const DataFailed('مشکلی در ذخیره اطلاعات کاربر رخ داده است.');
    }
  }

  @override
  Future<DataState<UserEntity>> update(UserEntity userEntity) async {
    try {
      await _userDB.update(User.fromEntity(userEntity));
      return DataSuccess(userEntity);
    } on Exception catch (_) {
      return const DataFailed('مشکلی در بروزرسانی اطلاعات کاربر رخ داده است.');
    }
  }

  @override
  Future<DataState<String>> deleteUserLogo(int id) async {
    try {
      await _userDB.deleteLogo(id);
      return const DataSuccess('حذف انجام شد.');
    } on Exception catch (_) {
      return const DataFailed('مشکلی در حذف رخ داده است.');
    }
  }
}

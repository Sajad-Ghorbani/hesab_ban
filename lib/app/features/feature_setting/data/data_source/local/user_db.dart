import 'package:hesab_ban/app/core/db_helper/db_helper.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/user_model.dart';
import 'package:hive/hive.dart';

class UserDB extends DBHelper<User> {
  final _userBox = Hive.box<User>(Constants.userBox);

  @override
  Future<void> delete(int id) {
    throw UnimplementedError();
  }

  @override
  List<User> getAll() {
    throw UnimplementedError();
  }

  @override
  User? getById(int id) {
    return _userBox.get(id);
  }

  @override
  Future<void> save(User value) async {
    int id = await _userBox.add(value);
    value.id = id;
    value.save();
  }

  @override
  Future<void> update(User value) async {
    User? user = _userBox.get(value.id);
    if (user != null) {
      user.name = value.name ?? user.name;
      user.storeLogo = value.storeLogo ?? user.storeLogo;
      user.storeName = value.storeName ?? user.storeName;
      user.phoneNumber = value.phoneNumber ?? user.phoneNumber;
      user.storeAddress = value.storeAddress ?? user.storeAddress;
      user.hashedPassword = value.hashedPassword ?? user.hashedPassword;
      await user.save();
    }
  }

  Future<void> deleteLogo(int id) async {
    User? user = _userBox.get(id);
    if (user != null) {
      user.storeLogo = null;
      await user.save();
    }
  }
}

import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_setting/data/data_source/local/setting_db.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/setting_model.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/setting_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository{
  final SettingDB _settingDB;

  SettingRepositoryImpl(this._settingDB);

  @override
  DataState<SettingEntity> getSettings() {
      try {
        var response = _settingDB.get();
        return DataSuccess(response!.toEntity());
      } catch (_) {
        return const DataFailed('مشکلی در دریافت تنظیمات رخ داده است.');
      }

  }

  @override
  Future<DataState<String>> save() async{
    try {
      await _settingDB.save();
      return const DataSuccess('تنظیمات ذخیره شد.');
    } catch (_) {
      return const DataFailed('مشکلی در ذخیره تنظیمات رخ داده است.');
    }
  }

  @override
  Future<DataState<SettingEntity>> update(SettingEntity settingEntity)async {
    try {
      await _settingDB.update(Setting.fromEntity(settingEntity));
      return DataSuccess(settingEntity);
    } catch (_) {
      return const DataFailed('مشکلی در بروزرسانی تنظیمات رخ داده است.');
    }
  }

  @override
  Future<DataState<String>> deleteFromSetting(String value) async{
    try {
      await _settingDB.deleteFromSetting(value);
      return const DataSuccess('حذف انجام شد.');
    } catch (_) {
      return const DataFailed('مشکلی در حذف رخ داده است.');
    }
  }
}
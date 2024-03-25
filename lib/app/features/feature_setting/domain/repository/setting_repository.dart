import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/setting_entity.dart';

abstract class SettingRepository{
  Future<DataState<String>> save();

  Future<DataState<SettingEntity>> update(SettingEntity settingEntity);

  DataState<SettingEntity> getSettings();

  Future<DataState<String>> deleteFromSetting(String value);
}
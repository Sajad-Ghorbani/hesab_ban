import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/entities/setting_entity.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/setting_repository.dart';

class GetSettingUseCase extends UseCase<DataState<SettingEntity>>{
  final SettingRepository _settingRepository;

  GetSettingUseCase(this._settingRepository);

  @override
  DataState<SettingEntity> call() {
    return _settingRepository.getSettings();
  }
}
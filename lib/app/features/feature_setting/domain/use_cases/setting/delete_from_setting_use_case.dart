import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/setting_repository.dart';

class DeleteFromSettingUseCase extends AsyncUseCase<DataState<String>, String> {
  final SettingRepository _settingRepository;

  DeleteFromSettingUseCase(this._settingRepository);

  @override
  Future<DataState<String>> call(String params) async {
    return await _settingRepository.deleteFromSetting(params);
  }
}

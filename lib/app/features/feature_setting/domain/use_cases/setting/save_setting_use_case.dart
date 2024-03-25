import 'package:hesab_ban/app/core/resources/data_state.dart';
import 'package:hesab_ban/app/core/use_case/use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/setting_repository.dart';

class SaveSettingUseCase extends AsyncUseCase<DataState<String>,NoParams>{
  final SettingRepository _settingRepository;

  SaveSettingUseCase(this._settingRepository);

  @override
  Future<DataState<String>> call(NoParams params) async{
    return _settingRepository.save();
  }
}
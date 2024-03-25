import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/delete_from_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/update_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/delete_user_logo_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/save_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/update_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';

class SettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SettingController(
      Get.find<SaveUserUseCase>(),
      Get.find<UpdateUserUseCase>(),
      Get.find<GetUserByIdUseCase>(),
      Get.find<UpdateSettingUseCase>(),
      Get.find<GetSettingUseCase>(),
      Get.find<DeleteFromSettingUseCase>(),
      Get.find<DeleteUserLogoUseCase>(),
    ));
  }
}

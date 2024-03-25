import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/delete_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/get_all_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/save_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/update_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';

class CheckBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CheckController>(
      CheckController(
        Get.find<SaveCheckUseCase>(),
        Get.find<UpdateCheckUseCase>(),
        Get.find<GetAllCheckUseCase>(),
        Get.find<DeleteCheckUseCase>(),
      ),
    );
  }
}

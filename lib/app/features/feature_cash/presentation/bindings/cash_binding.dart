import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/delete_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/get_all_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/save_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/update_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/controller/cash_controller.dart';

class CashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CashController>(CashController(
      Get.find<SaveCashUseCase>(),
      Get.find<UpdateCashUseCase>(),
      Get.find<GetAllCashUseCase>(),
      Get.find<DeleteCashUseCase>(),
    ));
  }
}

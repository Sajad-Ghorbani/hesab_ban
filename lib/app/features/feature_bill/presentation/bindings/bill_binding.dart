import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/add_to_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/delete_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/get_all_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/get_bill_by_id.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/remove_from_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/save_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_cash_of_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_check_of_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_customer_bill.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/use_cases/update_factor_of_bill_use_case.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/controller/bill_controller.dart';

class BillBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BillController>(
      BillController(
        Get.find<SaveBillUseCase>(),
        Get.find<DeleteBillUseCase>(),
        Get.find<UpdateFactorOfBillUseCase>(),
        Get.find<GetAllBillUseCase>(),
        Get.find<UpdateCashOfBillUseCase>(),
        Get.find<UpdateCheckOfBillUseCase>(),
        Get.find<GetBillByIdUseCase>(),
        Get.find<AddToBillUseCase>(),
        Get.find<RemoveFromBillUseCase>(),
        Get.find<UpdateCustomerBillUseCase>(),
      ),
    );
  }
}

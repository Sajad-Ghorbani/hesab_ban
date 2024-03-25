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
import 'package:hesab_ban/app/features/feature_check/presentation/controller/check_controller.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/controller/home_controller.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/delete_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/get_all_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/get_category_by_name_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/save_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/update_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/delete_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/get_all_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/save_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/update_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/delete_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/get_all_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/get_by_name_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/save_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/update_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/controller/product_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/delete_from_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/delete_user_logo_use_case.dart';
import 'package:hesab_ban/app/features/feature_splash/presentation/controller/splash_controller.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/update_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/save_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/update_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/setting_controller.dart';

import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController(Get.find()));
    Get.put(SettingController(
      Get.find<SaveUserUseCase>(),
      Get.find<UpdateUserUseCase>(),
      Get.find<GetUserByIdUseCase>(),
      Get.find<UpdateSettingUseCase>(),
      Get.find<GetSettingUseCase>(),
      Get.find<DeleteFromSettingUseCase>(),
      Get.find<DeleteUserLogoUseCase>(),
    ));
    Get.put(
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
    Get.put(CustomerController(
        Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    Get.put(CheckController(Get.find(), Get.find(), Get.find(), Get.find()));
    Get.put<HomeController>(
      HomeController(),
    );
    Get.put<ProductController>(
      ProductController(
        Get.find<SaveProductUseCase>(),
        Get.find<GetCategoryByNameUseCase>(),
        Get.find<UpdateProductUseCase>(),
        Get.find<SaveCategoryUseCase>(),
        Get.find<UpdateCategoryUseCase>(),
        Get.find<DeleteCategoryUseCase>(),
        Get.find<GetAllProductUseCase>(),
        Get.find<DeleteProductUseCase>(),
        Get.find<GetAllCategoryUseCase>(),
        Get.find<GetAllUnitOfProductUseCase>(),
        Get.find<GetByNameUnitOfProductUseCase>(),
        Get.find<DeleteUnitOfProductUseCase>(),
        Get.find<UpdateUnitOfProductUseCase>(),
        Get.find<SaveUnitOfProductUseCase>(),
      ),
    );
  }
}

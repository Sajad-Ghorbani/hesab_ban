import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/delete_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/get_all_customers_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/get_customer_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/save_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/update_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/controller/customer_controller.dart';

class CustomerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CustomerController>(
      CustomerController(
        Get.find<SaveCustomerUseCase>(),
        Get.find<UpdateCustomerUseCase>(),
        Get.find<GetAllCustomersUseCase>(),
        Get.find<DeleteCustomerUseCase>(),
        Get.find<GetCustomerByIdUseCase>(),
      ),
    );
  }
}

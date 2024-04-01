import 'package:get/get.dart';
import 'package:hesab_ban/app/core/utils/constants.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_bill/data/data_source/local/bill_db.dart';
import 'package:hesab_ban/app/features/feature_bill/data/models/bill_model.dart';
import 'package:hesab_ban/app/features/feature_bill/data/repository/bill_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_bill/domain/repository/bill_repository.dart';
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
import 'package:hesab_ban/app/features/feature_cash/data/data_source/local/cash_db.dart';
import 'package:hesab_ban/app/features/feature_cash/data/models/cash_model.dart';
import 'package:hesab_ban/app/features/feature_cash/data/repository/cash_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/repository/cash_repository.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/delete_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/get_all_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/save_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_cash/domain/use_cases/update_cash_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/data/data_source/local/check_db.dart';
import 'package:hesab_ban/app/features/feature_check/data/models/check_model.dart';
import 'package:hesab_ban/app/features/feature_check/data/repository/check_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_check/domain/repository/check_repository.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/delete_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/get_all_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/save_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_check/domain/use_cases/update_check_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/data/data_source/local/customer_db.dart';
import 'package:hesab_ban/app/features/feature_customer/data/models/customer_model.dart';
import 'package:hesab_ban/app/features/feature_customer/data/repository/customer_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/repository/customer_repository.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/delete_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/get_all_customers_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/get_customer_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/save_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_customer/domain/use_cases/update_customer_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/data/data_source/local/factor_db.dart';
import 'package:hesab_ban/app/features/feature_factor/data/models/factor_model.dart';
import 'package:hesab_ban/app/features/feature_factor/data/repository/factor_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/repository/factor_repository.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/delete_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/get_all_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/save_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_factor/domain/use_cases/update_factor_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/data/data_source/local/category_db.dart';
import 'package:hesab_ban/app/features/feature_product/data/data_source/local/product_db.dart';
import 'package:hesab_ban/app/features/feature_product/data/data_source/local/unit_db.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/category_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/product_model.dart';
import 'package:hesab_ban/app/features/feature_product/data/models/unit_of_product.dart';
import 'package:hesab_ban/app/features/feature_product/data/repository/category_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_product/data/repository/product_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_product/data/repository/unit_of_product_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/category_repository.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/product_repository.dart';
import 'package:hesab_ban/app/features/feature_product/domain/repository/unit_of_product_repository.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/delete_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/get_all_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/save_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/update_category_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/delete_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/get_all_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/category/get_category_by_name_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/save_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/product/update_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/delete_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/get_all_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/get_by_name_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/save_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_product/domain/use_cases/unit_of_product/update_unit_of_product_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/data/data_source/local/setting_db.dart';
import 'package:hesab_ban/app/features/feature_setting/data/data_source/local/user_db.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/setting_model.dart';
import 'package:hesab_ban/app/features/feature_setting/data/models/user_model.dart';
import 'package:hesab_ban/app/features/feature_setting/data/repository/setting_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_setting/data/repository/user_repository_impl.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/setting_repository.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/repository/user_repository.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/delete_from_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/save_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/setting/update_setting_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/delete_user_logo_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/save_user_use_case.dart';
import 'package:hesab_ban/app/features/feature_setting/domain/use_cases/user/update_user_use_case.dart';
import 'package:hive_flutter/hive_flutter.dart';

setup() async {
  await Hive.initFlutter();
  StaticMethods.hiveAdapters();

  ///open database
  await Hive.openBox<Bill>(Constants.billsBox);
  await Hive.openBox<Customer>(Constants.customersBox);
  await Hive.openBox<Cash>(Constants.cashBox);
  await Hive.openBox<Check>(Constants.checksBox);
  await Hive.openBox<Product>(Constants.allProductBox);
  await Hive.openBox<Factor>(Constants.factorBox);
  await Hive.openBox<Setting>(Constants.settingBox);
  await Hive.openBox<User>(Constants.userBox);
  var unitBox = await Hive.openBox<UnitOfProduct>(Constants.unitOfProductBox);
  var box = await Hive.openBox<Category>(Constants.productCategoryBox);
  if (box.isEmpty) {
    await box.add(Category(id: 0, name: Constants.defaultCategoryName));
  }
  if (unitBox.isEmpty) {
    for (int index = 0; index < Constants.firstUnits.length; index++) {
      await unitBox.add(
        UnitOfProduct(
          id: index,
          name: Constants.firstUnits[index],
        ),
      );
    }
  }

  ///inject database providers
  Get.put<BillDB>(BillDB());
  Get.put<CustomerDB>(CustomerDB());
  Get.put<CashDB>(CashDB());
  Get.put<CheckDB>(CheckDB());
  Get.put<ProductDB>(ProductDB());
  Get.put<CategoryDB>(CategoryDB());
  Get.put<FactorDB>(FactorDB());
  Get.put<SettingDB>(SettingDB());
  Get.put<UserDB>(UserDB());
  Get.put<UnitDb>(UnitDb());

  ///inject repositories
  Get.put<BillRepository>(BillRepositoryImpl(Get.find<BillDB>()));
  Get.put<CustomerRepository>(CustomerRepositoryImpl(Get.find<CustomerDB>()));
  Get.put<CashRepository>(CashRepositoryImpl(Get.find<CashDB>()));
  Get.put<CheckRepository>(CheckRepositoryImpl(Get.find<CheckDB>()));
  Get.put<ProductRepository>(ProductRepositoryImpl(Get.find<ProductDB>()));
  Get.put<CategoryRepository>(CategoryRepositoryImpl(Get.find<CategoryDB>()));
  Get.put<FactorRepository>(FactorRepositoryImpl(Get.find<FactorDB>()));
  Get.put<UserRepository>(UserRepositoryImpl(Get.find<UserDB>()));
  Get.put<SettingRepository>(SettingRepositoryImpl(Get.find<SettingDB>()));
  Get.put<UnitOfProductRepository>(
      UnitOfProductRepositoryImpl(Get.find<UnitDb>()));

  /// bill use cases
  Get.put<AddToBillUseCase>(AddToBillUseCase(Get.find<BillRepository>()));
  Get.put<DeleteBillUseCase>(DeleteBillUseCase(Get.find<BillRepository>()));
  Get.put<GetAllBillUseCase>(GetAllBillUseCase(Get.find<BillRepository>()));
  Get.put<GetBillByIdUseCase>(GetBillByIdUseCase(Get.find<BillRepository>()));
  Get.put<RemoveFromBillUseCase>(
      RemoveFromBillUseCase(Get.find<BillRepository>()));
  Get.put<SaveBillUseCase>(SaveBillUseCase(Get.find<BillRepository>()));
  Get.put<UpdateCustomerBillUseCase>(
      UpdateCustomerBillUseCase(Get.find<BillRepository>()));
  Get.put<UpdateCashOfBillUseCase>(
      UpdateCashOfBillUseCase(Get.find<BillRepository>()));
  Get.put<UpdateCheckOfBillUseCase>(
      UpdateCheckOfBillUseCase(Get.find<BillRepository>()));
  Get.put<UpdateFactorOfBillUseCase>(
      UpdateFactorOfBillUseCase(Get.find<BillRepository>()));

  /// cash use cases
  Get.put<SaveCashUseCase>(SaveCashUseCase(Get.find<CashRepository>()));
  Get.put<UpdateCashUseCase>(UpdateCashUseCase(Get.find<CashRepository>()));
  Get.put<DeleteCashUseCase>(DeleteCashUseCase(Get.find<CashRepository>()));
  Get.put<GetAllCashUseCase>(GetAllCashUseCase(Get.find<CashRepository>()));

  /// customer use cases
  Get.put<SaveCustomerUseCase>(
      SaveCustomerUseCase(Get.find<CustomerRepository>()));
  Get.put<UpdateCustomerUseCase>(UpdateCustomerUseCase(
    Get.find<CustomerRepository>(),
    Get.find<FactorRepository>(),
    Get.find<BillRepository>(),
  ));
  Get.put<DeleteCustomerUseCase>(
      DeleteCustomerUseCase(Get.find<CustomerRepository>()));
  Get.put<GetCustomerByIdUseCase>(
      GetCustomerByIdUseCase(Get.find<CustomerRepository>()));
  Get.put<GetAllCustomersUseCase>(
      GetAllCustomersUseCase(Get.find<CustomerRepository>()));

  /// check use cases
  Get.put<SaveCheckUseCase>(SaveCheckUseCase(Get.find<CheckRepository>()));
  Get.put<UpdateCheckUseCase>(UpdateCheckUseCase(Get.find<CheckRepository>()));
  Get.put<DeleteCheckUseCase>(DeleteCheckUseCase(Get.find<CheckRepository>()));
  Get.put<GetAllCheckUseCase>(GetAllCheckUseCase(Get.find<CheckRepository>()));

  /// product use cases
  Get.put<SaveProductUseCase>(
      SaveProductUseCase(Get.find<ProductRepository>()));
  Get.put<UpdateProductUseCase>(
      UpdateProductUseCase(Get.find<ProductRepository>()));
  Get.put<DeleteProductUseCase>(
      DeleteProductUseCase(Get.find<ProductRepository>()));
  Get.put<GetAllProductUseCase>(
      GetAllProductUseCase(Get.find<ProductRepository>()));

  /// category use cases
  Get.put<SaveCategoryUseCase>(
      SaveCategoryUseCase(Get.find<CategoryRepository>()));
  Get.put<UpdateCategoryUseCase>(
      UpdateCategoryUseCase(Get.find<CategoryRepository>()));
  Get.put<DeleteCategoryUseCase>(
      DeleteCategoryUseCase(Get.find<CategoryRepository>()));
  Get.put<GetAllCategoryUseCase>(
      GetAllCategoryUseCase(Get.find<CategoryRepository>()));
  Get.put<GetCategoryByNameUseCase>(
      GetCategoryByNameUseCase(Get.find<CategoryRepository>()));

  /// unit of product use cases
  Get.put<GetAllUnitOfProductUseCase>(
      GetAllUnitOfProductUseCase(Get.find<UnitOfProductRepository>()));
  Get.put<GetByNameUnitOfProductUseCase>(
      GetByNameUnitOfProductUseCase(Get.find<UnitOfProductRepository>()));
  Get.put<DeleteUnitOfProductUseCase>(
      DeleteUnitOfProductUseCase(Get.find<UnitOfProductRepository>()));
  Get.put<UpdateUnitOfProductUseCase>(
      UpdateUnitOfProductUseCase(Get.find<UnitOfProductRepository>()));
  Get.put<SaveUnitOfProductUseCase>(
      SaveUnitOfProductUseCase(Get.find<UnitOfProductRepository>()));

  /// factor use cases
  Get.put<SaveFactorUseCase>(SaveFactorUseCase(Get.find<FactorRepository>()));
  Get.put<UpdateFactorUseCase>(
      UpdateFactorUseCase(Get.find<FactorRepository>()));
  Get.put<DeleteFactorUseCase>(
      DeleteFactorUseCase(Get.find<FactorRepository>()));
  Get.put<GetAllFactorUseCase>(
      GetAllFactorUseCase(Get.find<FactorRepository>()));

  /// user use cases
  Get.put<SaveUserUseCase>(SaveUserUseCase(Get.find<UserRepository>()));
  Get.put<UpdateUserUseCase>(UpdateUserUseCase(Get.find<UserRepository>()));
  Get.put<GetUserByIdUseCase>(GetUserByIdUseCase(Get.find<UserRepository>()));
  Get.put<DeleteUserLogoUseCase>(
      DeleteUserLogoUseCase(Get.find<UserRepository>()));

  /// setting use cases
  Get.put<SaveSettingUseCase>(
      SaveSettingUseCase(Get.find<SettingRepository>()));
  Get.put<UpdateSettingUseCase>(
      UpdateSettingUseCase(Get.find<SettingRepository>()));
  Get.put<GetSettingUseCase>(GetSettingUseCase(Get.find<SettingRepository>()));
  Get.put<DeleteFromSettingUseCase>(
      DeleteFromSettingUseCase(Get.find<SettingRepository>()));
}

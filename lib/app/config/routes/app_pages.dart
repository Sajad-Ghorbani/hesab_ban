import 'package:hesab_ban/app/features/feature_bill/presentation/bindings/bill_binding.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/bindings/cash_binding.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/screens/all_cash_screen.dart';
import 'package:hesab_ban/app/features/feature_cash/presentation/screens/create_cash_screen.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/screens/all_check_screen.dart';
import 'package:hesab_ban/app/features/feature_check/presentation/screens/create_check_screen.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/screens/all_customer_screen.dart';
import 'package:hesab_ban/app/features/feature_customer/presentation/screens/create_customer_screen.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/bindings/factor_binding.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/screens/all_factor_screen.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/screens/amounts_screen.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/screens/factor_screen.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/screens/one_sale_factor_screen.dart';
import 'package:hesab_ban/app/features/feature_factor/presentation/screens/select_factor_screen.dart';
import 'package:hesab_ban/app/features/feature_home/presentation/screens/main_screen.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/bindings/password_binding.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/screens/change_password_screen.dart';
import 'package:hesab_ban/app/features/feature_password/presentation/screens/password_screen.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/screens/all_product_screen.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/screens/create_product_screen.dart';
import 'package:hesab_ban/app/features/feature_product/presentation/screens/manage_units_screen.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/password_setting_screen.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/setting_screen.dart';
import 'package:hesab_ban/app/features/feature_backup/presentation/bindings/backup_binding.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/signature/drawing_page.dart';
import 'package:hesab_ban/app/features/feature_backup/presentation/screens/backup_screen.dart';
import 'package:hesab_ban/app/features/feature_bill/presentation/screens/customer_balance_screen.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/screens/privacy_and_policy_screen.dart';
import 'package:hesab_ban/app/features/feature_splash/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => const MainScreen(),
    ),
    GetPage(
      name: Routes.createProductScreen,
      page: () => const CreateProductScreen(),
    ),
    GetPage(
      name: Routes.allProductScreen,
      page: () => const AllProductScreen(),
    ),
    GetPage(
      name: Routes.createCustomerScreen,
      page: () => const CreateCustomerScreen(),
      binding: BillBinding(),
    ),
    GetPage(
      name: Routes.customerBalanceScreen,
      page: () => const CustomerBalanceScreen(),
    ),
    GetPage(
      name: Routes.allCustomerScreen,
      page: () => const AllCustomerScreen(),
    ),
    GetPage(
      name: Routes.createCheckScreen,
      page: () => const CreateCheckScreen(),
    ),
    GetPage(
      name: Routes.allCheckScreen,
      page: () => const AllCheckScreen(),
    ),
    GetPage(
      name: Routes.selectFactorScreen,
      page: () => const SelectFactorScreen(),
    ),
    GetPage(
      name: Routes.oneSaleFactorScreen,
      page: () => const OneSaleFactorScreen(),
      binding: FactorBinding(),
    ),
    GetPage(
      name: Routes.allFactorScreen,
      page: () => const AllFactorScreen(),
      binding: FactorBinding(),
    ),
    GetPage(
      name: Routes.amountsScreen,
      page: () => const AmountsScreen(),
    ),
    GetPage(
      name: Routes.factorScreen,
      page: () => const FactorScreen(),
    ),
    GetPage(
      name: Routes.privacyAndPolicyScreen,
      page: () => const PrivacyAndPolicyScreen(),
    ),
    GetPage(
      name: Routes.settingScreen,
      page: () => const SettingScreen(),
    ),
    GetPage(
      name: Routes.passwordScreen,
      page: () => const PasswordScreen(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: Routes.changePasswordScreen,
      page: () => const ChangePasswordScreen(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: Routes.passwordSettingScreen,
      page: () => const PasswordSettingScreen(),
    ),
    GetPage(
      name: Routes.signatureScreen,
      page: () => const DrawingPage(),
    ),
    GetPage(
      name: Routes.backupScreen,
      page: () => const BackupScreen(),
      binding: BackupBinding(),
    ),
    GetPage(
      name: Routes.manageUnitsScreen,
      page: () => const ManageUnitsScreen(),
    ),
    GetPage(
      name: Routes.createCashScreen,
      page: () => const CreateCashScreen(),
      binding: CashBinding(),
    ),
    GetPage(
      name: Routes.allCashScreen,
      page: () => const AllCashScreen(),
      binding: CashBinding(),
    ),
  ];
}

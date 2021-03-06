import 'package:hesab_ban/bindings/backup_binding.dart';
import 'package:hesab_ban/bindings/check_binding.dart';
import 'package:hesab_ban/bindings/customer_binding.dart';
import 'package:hesab_ban/bindings/factor_binding.dart';
import 'package:hesab_ban/bindings/home_binding.dart';
import 'package:hesab_ban/bindings/initial_binding.dart';
import 'package:hesab_ban/bindings/product_binding.dart';
import 'package:hesab_ban/ui/screens/backup_screen.dart';
import 'package:hesab_ban/ui/screens/create_check_screen.dart';
import 'package:hesab_ban/ui/screens/create_customer_screen.dart';
import 'package:hesab_ban/ui/screens/customer_balance_screen.dart';
import 'package:hesab_ban/ui/screens/customers_screen.dart';
import 'package:hesab_ban/ui/screens/factor_screen.dart';
import 'package:hesab_ban/ui/screens/main_screen.dart';
import 'package:hesab_ban/ui/screens/one_sale_factor_screen.dart';
import 'package:hesab_ban/ui/screens/create_product_screen.dart';
import 'package:hesab_ban/ui/screens/all_product_screen.dart';
import 'package:hesab_ban/ui/screens/privacy_and_policy_screen.dart';
import 'package:hesab_ban/ui/screens/splash_screen.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => const MainScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.createProductScreen,
      page: () => const CreateProductScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.allProductScreen,
      page: () => const AllProductScreen(),
    ),
    GetPage(
      name: Routes.createCustomerScreen,
      page: () => const CreateCustomerScreen(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.customerBalanceScreen,
      page: () => const CustomerBalanceScreen(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.customersScreen,
      page: () => const CustomersScreen(),
    ),
    GetPage(
      name: Routes.createCheckScreen,
      page: () => const CreateCheckScreen(),
      binding: CheckBinding(),
    ),
    GetPage(
      name: Routes.oneSaleFactorScreen,
      page: () => const OneSaleFactorScreen(),
      binding: FactorBinding(),
    ),
    GetPage(
      name: Routes.factorScreen,
      page: () => const FactorScreen(),
      binding: FactorBinding(),
    ),
    GetPage(
      name: Routes.privacyAndPolicyScreen,
      page: () => const PrivacyAndPolicyScreen(),
    ),
    GetPage(
      name: Routes.backupScreen,
      page: () => const BackupScreen(),
      binding: BackupBinding(),
    ),
  ];
}

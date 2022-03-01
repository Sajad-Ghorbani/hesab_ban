import 'package:hesab_ban/bindings/check_binding.dart';
import 'package:hesab_ban/bindings/customer_binding.dart';
import 'package:hesab_ban/bindings/home_binding.dart';
import 'package:hesab_ban/ui/screens/create_check_screen.dart';
import 'package:hesab_ban/ui/screens/create_customer_screen.dart';
import 'package:hesab_ban/ui/screens/customer_balance_screen.dart';
import 'package:hesab_ban/ui/screens/main_screen.dart';
import 'package:hesab_ban/ui/screens/product_screen.dart';
import 'package:hesab_ban/ui/screens/splash_screen.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(name: Routes.initial, page: () => const SplashScreen()),
    GetPage(
      name: Routes.mainScreen,
      page: () => const MainScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.productScreen,
      page: () => const ProductScreen(),
    ),
    GetPage(
      name: Routes.createCustomerScreen,
      page: () => const CreateCustomerScreen(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: Routes.customerBalanceScreen,
      page: () => const CustomerBalanceScreen(),
    ),
    GetPage(
      name: Routes.createCheckScreen,
      page: () => const CreateCheckScreen(),
      binding: CheckBinding(),
    ),
  ];
}

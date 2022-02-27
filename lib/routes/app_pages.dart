import 'package:accounting_app/bindings/home_binding.dart';
import 'package:accounting_app/ui/screens/create_customer_screen.dart';
import 'package:accounting_app/ui/screens/customer_balance_screen.dart';
import 'package:accounting_app/ui/screens/main_screen.dart';
import 'package:accounting_app/ui/screens/product_screen.dart';
import 'package:accounting_app/ui/screens/splash_screen.dart';
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
    ),
    GetPage(
      name: Routes.customerBalanceScreen,
      page: () => const CustomerBalanceScreen(),
    ),
  ];
}

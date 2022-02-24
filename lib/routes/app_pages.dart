import 'package:accounting_app/ui/screens/main_screen.dart';
import 'package:accounting_app/ui/screens/product_screen.dart';
import 'package:accounting_app/ui/screens/splash_screen.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(name: Routes.initial, page: () => const SplashScreen()),
    GetPage(name: Routes.mainScreen, page: () => const MainScreen()),
    GetPage(name: Routes.productScreen, page: () => const ProductScreen()),
  ];
}

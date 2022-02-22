import 'package:accounting_app/ui/screens/home_screen.dart';
import 'package:accounting_app/ui/screens/splash_screen.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(name: Routes.initial, page: () => const SplashScreen()),
    GetPage(name: Routes.homeScreen, page: () => const HomeScreen()),
  ];
}

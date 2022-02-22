import 'package:accounting_app/bindings/app_bindings.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:accounting_app/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      locale: const Locale('fa','IR'),
      fallbackLocale: const Locale('en', 'US'),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 200),
      theme: AppThemeData.darkTheme,
    );
  }
}


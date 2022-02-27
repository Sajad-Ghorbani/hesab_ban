import 'package:accounting_app/bindings/initial_binding.dart';
import 'package:accounting_app/models/bill_model.dart';
import 'package:accounting_app/models/category_model.dart';
import 'package:accounting_app/models/check_model.dart';
import 'package:accounting_app/models/customer_model.dart';
import 'package:accounting_app/models/factor_model.dart';
import 'package:accounting_app/models/product_model.dart';
import 'package:accounting_app/models/user_model.dart';
import 'package:accounting_app/routes/app_pages.dart';
import 'package:accounting_app/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main()async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UnitAdapter());
  Hive.registerAdapter(FactorAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(CheckAdapter());
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(CategoryAdapter());
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
      initialBinding: InitialBinding(),
      locale: const Locale('fa','IR'),
      fallbackLocale: const Locale('en', 'US'),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 200),
      theme: AppThemeData.darkTheme,
    );
  }
}


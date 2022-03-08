import 'package:hesab_ban/bindings/initial_binding.dart';
import 'package:hesab_ban/models/bill_model.dart';
import 'package:hesab_ban/models/category_model.dart';
import 'package:hesab_ban/models/check_model.dart';
import 'package:hesab_ban/models/customer_model.dart';
import 'package:hesab_ban/models/factor_model.dart';
import 'package:hesab_ban/models/factor_row.dart';
import 'package:hesab_ban/models/product_model.dart';
import 'package:hesab_ban/models/user_model.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main()async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UnitAdapter());
  Hive.registerAdapter(FactorAdapter());
  Hive.registerAdapter(FactorRowAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(CheckAdapter());
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TypeOfCheckAdapter());
  Hive.registerAdapter(TypeOfFactorAdapter());
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


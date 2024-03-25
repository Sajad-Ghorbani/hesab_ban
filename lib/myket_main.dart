import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hesab_ban/app/config/routes/app_pages.dart';
import 'package:hesab_ban/app/core/utils/custom_error.dart';
import 'package:hesab_ban/app/core/utils/static_methods.dart';
import 'package:hesab_ban/app/features/feature_setting/presentation/controller/notification_service.dart';
import 'package:hesab_ban/app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/app/features/feature_splash/presentation/bindings/initial_binding.dart';

void main() async {
  await setup();
  // set orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await NotificationService().initializationNotification();
  FlavorConfig(
    name: "myket",
    variables: {
      "appLink": "https://myket.ir/app/com.nahal1401.hesab_ban",
      'name': 'مایکت',
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'حساب بان',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
      locale: const Locale('fa', 'IR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''),
        Locale('en', ''),
      ],
      fallbackLocale: const Locale('en', 'US'),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 200),
      theme: StaticMethods(Get.find()).getThemeMode(),
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomError(errorDetails: errorDetails);
        };
        return widget!;
      },
    );
  }
}

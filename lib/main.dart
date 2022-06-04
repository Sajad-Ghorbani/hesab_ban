import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hesab_ban/routes/app_pages.dart';
import 'package:hesab_ban/static_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/ui/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  StaticMethods.hiveAdapters();
  // open the box for theme of the app
  await Hive.openBox('theme');

  // set orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_notification_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notification',
        channelDescription: 'Notification channel for basic tests',
        enableLights: true,
        enableVibration: true,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData getThemeMode() {
    final boxSetting = Hive.box('theme');
    bool? isLightTheme = boxSetting.get('isLightTheme');
    if (isLightTheme == null) {
      boxSetting.put('isLightTheme', false);
      isLightTheme = false;
    }
    return isLightTheme ? AppThemeData.lightTheme : AppThemeData.darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'حساب بان',
      debugShowCheckedModeBanner: false,
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
      theme: getThemeMode(),
    );
  }
}

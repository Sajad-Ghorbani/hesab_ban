import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: kBackgroundColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: kDarkGreyColor,
        onPrimary: kWhiteColor,
        secondary: kPurpleColor,
        onSecondary: Colors.white,
        error: kRedColor,
        onError: kWhiteColor,
        background: kBackgroundColor,
        onBackground: kGreyColor,
        surface: kSurfaceColor,
        onSurface: kWhiteColor,
      ),
      fontFamily: 'Yekan',
      appBarTheme: const AppBarTheme(
        elevation: 1,
        toolbarHeight: 60,
      ),
      textTheme: const TextTheme(
        bodyText2: kBodyText,
        bodyText1: kBodyLarge,
        headline6: kBodyMedium,
      ),
    );
  }
}

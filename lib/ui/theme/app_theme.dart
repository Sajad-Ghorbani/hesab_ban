import 'package:hesab_ban/ui/theme/app_colors.dart';
import 'package:hesab_ban/ui/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
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
        onBackground: kWhiteColor,
        surface: kSurfaceColor,
        onSurface: kWhiteColor,
      ),
      cardColor: kGreyColor,
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

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: kWhiteColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: kPinkColor,
        onPrimary: kWhiteColor,
        secondary: kPurpleColor,
        onSecondary: kWhiteColor,
        error: kRedColor,
        onError: kWhiteColor,
        background: kWhiteColor,
        onBackground: kDarkGreyColor,
        surface: kSurfaceLightColor,
        onSurface: kSurfaceColor,
      ),
      cardColor: kWhiteBlueColor,
      dialogBackgroundColor: kWhiteGreyColor,
      cardTheme: const CardTheme(
        shadowColor: kBlueColor,
        // color: kWhiteBlueColor,
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

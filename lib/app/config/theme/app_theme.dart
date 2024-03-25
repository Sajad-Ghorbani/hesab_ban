import 'package:flutter/material.dart';
import 'package:hesab_ban/app/config/theme/app_colors.dart';
import 'package:hesab_ban/app/config/theme/app_text_theme.dart';

class AppThemeData {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBackgroundColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: kDarkGreyColor,
        onPrimary: kWhiteColor,
        secondary: kPurpleColor,
        onSecondary: kWhiteColor,
        error: kRedColor,
        onError: kWhiteColor,
        background: kBackgroundColor,
        onBackground: kWhiteColor,
        surface: kSurfaceColor,
        onSurface: kWhiteColor,
      ),
      disabledColor: kGreyColor,
      cardColor: kGreyColor,
      cardTheme: const CardTheme(
        color: kGreyColor,
      ),
      fontFamily: 'Yekan',
      appBarTheme: const AppBarTheme(
        elevation: 1,
        toolbarHeight: 60,
        backgroundColor: kSurfaceColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: kBodyMedium,
        headlineLarge: kHeadlineLarge,
        titleLarge: kTitleLarge,
        bodyLarge: kBodyLarge,
      ),
      dividerTheme: const DividerThemeData(
        color: kGreyColor,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
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
      disabledColor: Colors.grey,
      cardColor: kWhiteBlueColor,
      dialogBackgroundColor: kWhiteGreyColor,
      cardTheme: const CardTheme(
        shadowColor: kBlueColor,
        color: kWhiteBlueColor,
      ),
      fontFamily: 'Yekan',
      appBarTheme: AppBarTheme(
        elevation: 1,
        toolbarHeight: 60,
        backgroundColor: kPinkColor,
        titleTextStyle: kTitleLarge.copyWith(
          fontFamily: 'Yekan',
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: kWhiteColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: kBodyMedium,
        headlineLarge: kHeadlineLarge,
        titleLarge: kTitleLarge,
        bodyLarge: kBodyLarge,
      ),
      dividerTheme: DividerThemeData(
        color: kGreyColor.withOpacity(0.6),
      ),
    );
  }
}

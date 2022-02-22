import 'package:accounting_app/ui/theme/app_colors.dart';
import 'package:accounting_app/ui/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData();

class AppThemeData {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: kBlueColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: kTealColor,
        onPrimary: kBlack,
        secondary: kLightYellow,
        onSecondary: kLightBlack,
        error: kLightRed,
        onError: kLightGrey,
        background: kBlueColor,
        onBackground: kBlack,
        surface: kLightTealColor,
        onSurface: kLightBlack,
      ),
      fontFamily: 'IranSans',
      textTheme: TextTheme(
        bodyText2: kBodyText,
        bodyLarge: kBodyLarge,
        bodyMedium: kBodyMedium,
      ),
    );
  }
}

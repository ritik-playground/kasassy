import 'package:flutter/material.dart';
import 'package:kasassy/constants/palette.dart';
import 'package:kasassy/constants/styles.dart';

class Themes {
  static final ThemeData light = ThemeData(
    primaryColor: Palette.primaryColor,
    backgroundColor: Palette.primaryColor,
    scaffoldBackgroundColor: Palette.primaryColor,
    primarySwatch: Palette.secondaryColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Palette.redColor,
      unselectedItemColor: Palette.darkColor,
      showUnselectedLabels: false,
    ),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Palette.secondaryColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        headline6: TextStyles.appBarHeading,
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: TextStyles.appBarHeading,
      ).headline6,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Palette.secondaryColor,
    ),
  );
}

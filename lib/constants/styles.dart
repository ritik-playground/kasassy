import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasassy/constants/palette.dart';

class Styles {
  static const SystemUiOverlayStyle style = SystemUiOverlayStyle(
    statusBarColor: Palette.transparentColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Palette.whiteColor,
    systemNavigationBarDividerColor: Palette.greyColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

class TextStyles {
  static TextStyle appBarHeading = const TextStyle(
    color: Palette.whiteColor,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
}

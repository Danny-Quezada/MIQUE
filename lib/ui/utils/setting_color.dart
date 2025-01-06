import 'package:flutter/material.dart';

class SettingColor {
  static const Color principalColor = Color(0xff4D96FF);
  static const Color redColor = Color(0xffFF6B6B);
  static const Color greenColor = Color(0xff6BCB77);
  static const Color borderColor = Color(0xFFC2BFBF);

  static ThemeData themeData = ThemeData(
      useMaterial3: true,
      fontFamily: "Onest",
      colorScheme: ColorScheme.fromSeed(seedColor: principalColor),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: borderColor),
        ),
      ));
}

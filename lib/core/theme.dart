import 'package:flutter/material.dart';

class NeonColors {
  static const background = Color(0xFF03020A);
  static const background2 = Color(0xFF090414);
  static const surface = Color(0xFF10091C);

  static const cyan = Color(0xFF39F4FF);
  static const pink = Color(0xFFFF32D2);
  static const purple = Color(0xFF8B4DFF);
  static const green = Color(0xFF49FF9A);
  static const orange = Color(0xFFFF9138);
  static const blue = Color(0xFF4A8DFF);
  static const yellow = Color(0xFFFFD34E);
}

ThemeData neonTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: NeonColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: NeonColors.cyan,
      brightness: Brightness.dark,
    ),
  );
}

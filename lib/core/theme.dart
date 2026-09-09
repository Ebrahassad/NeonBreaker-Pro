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

/// Selectable background color themes (Settings > Background).
/// Each entry is a 3-stop gradient used for both the home screen and the
/// in-game background.
class BackgroundThemes {
  static const List<String> names = [
    'White',
    'Dark Gray',
  ];

  static const List<List<Color>> gradients = [
    [
      Color(0xFFFFFFFF),
      Color(0xFFF1F1F1),
      Color(0xFFDCDCDC),
    ],
    [
      Color(0xFF303030),
      Color(0xFF181818),
      Color(0xFF080808),
    ],
  ];

  static const List<Color> swatch = [
    Color(0xFFFFFFFF),
    Color(0xFF606060),
  ];

  static List<Color> colorsFor(int index) {
    return gradients[index.clamp(0, gradients.length - 1)];
  }
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

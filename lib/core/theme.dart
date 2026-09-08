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
    'Nebula Purple',
    'Cyan Ocean',
    'Emerald',
    'Crimson',
    'Void Black',
  ];

  static const List<List<Color>> gradients = [
    // Nebula Purple (default)
    [Color(0xFF1B0A35), Color(0xFF090417), Color(0xFF020208)],
    // Cyan Ocean
    [Color(0xFF07253A), Color(0xFF03121F), Color(0xFF010508)],
    // Emerald
    [Color(0xFF0A2E1F), Color(0xFF06170F), Color(0xFF010805)],
    // Crimson
    [Color(0xFF3A0A1E), Color(0xFF1A0410), Color(0xFF080106)],
    // Void Black
    [Color(0xFF16161C), Color(0xFF0A0A0E), Color(0xFF030304)],
  ];

  /// Accent swatch shown for each theme's picker button.
  static const List<Color> swatch = [
    NeonColors.purple,
    NeonColors.cyan,
    NeonColors.green,
    NeonColors.pink,
    Color(0xFF9AA0AE),
  ];

  static List<Color> colorsFor(int index) {
    if (index < 0 || index >= gradients.length) {
      return gradients[0];
    }
    return gradients[index];
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

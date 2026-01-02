import 'package:flutter/material.dart';

class ThemePreset {
  final String name;
  final Color accent;
  final Color background;
  final String code;

  ThemePreset({
    required this.name,
    required this.accent,
    required this.background,
    required this.code,
  });
}

class AppTheme {
  static ThemeData create(Color accent, Color bg) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: accent,
      colorScheme: ColorScheme.dark(primary: accent, surface: bg),
      // This fixes the "TextField yellow line" and blue defaults
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withOpacity(0.3),
      ),
    );
  }

  // Signature Colors
  static const Color darkBg = Color(0xFF05070A);
  static const Color piggyPink = Color(0xFFFF2D55);
  static const Color heroBlue = Color(0xFF007AFF);
  static const Color lightBg = Color(0xFFF5F7FA);

  // The "City" Presets for the Settings Screen
  static List<ThemePreset> presets = [
    ThemePreset(
      name: "PIGGY (ПО ПОДРАЗБИРАНЕ)",
      accent: piggyPink,
      background: darkBg,
      code: "FF2D55-05070A",
    ),
    ThemePreset(
      name: "БИЗНЕС СИНЬО",
      accent: heroBlue,
      background: lightBg,
      code: "007AFF-F5F7FA",
    ),
    ThemePreset(
      name: "ПАРЕ (ЗЕЛЕНО)",
      accent: const Color(0xFF34C759), // Rich Money Green
      background: const Color(0xFF1C1C1E),
      code: "34C759-1C1C1E",
    ),
    ThemePreset(
      name: "ЗАЛЕЗ",
      accent: const Color(0xFFFF9500),
      background: const Color(0xFF1A0F0A),
      code: "FF9500-1A0F0A",
    ),
    ThemePreset(
      name: "ПЕРСОНАЛИЗИРАН",
      accent: const Color(0xFFBF5AF2), // Electric Purple
      background: const Color(0xFF0A0A0A),
      code: "BF5AF2-0A0A0A",
    ),
  ];

  // FIXED: This now matches exactly what main.dart is calling
  static ThemeData buildTheme({
    required Color accent,
    required Color background,
  }) {
    final isDark = background.computeLuminance() < 0.5;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: accent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: isDark ? Brightness.dark : Brightness.light,
        surface: background,
      ),
      // Consistent glass-style input theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        labelStyle: TextStyle(color: accent.withValues(alpha: 0.7)),
      ),
      // Centralized Text Styles
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black,
        ),
      ),
    );
  }
}

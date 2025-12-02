import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF13ECA4);
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF10221C);
  static const Color mint = Color(0xFFA8E6CF);
  static const Color green = Color(0xFF4CAF50);
  static const Color limeAccent = Color(0xFFCCFF90);
  static const Color freshMint = Color(0xFF84FAB0);
  static const Color freshGreen = Color(0xFF8FD3F4);

  static const String fontFamily = 'Noto Sans KR';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: freshMint,
        surface: backgroundLight,
        error: Colors.red,
        onPrimary: Colors.black, // Assuming black text on bright primary
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: const [
        AppColorsExtension(
          mint: mint,
          green: green,
          limeAccent: limeAccent,
          freshMint: freshMint,
          freshGreen: freshGreen,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: freshMint,
        surface: backgroundDark,
        error: Colors.red,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF09090B), // zinc-950 approximation
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: const [
        AppColorsExtension(
          mint: mint,
          green: green,
          limeAccent: limeAccent,
          freshMint: freshMint,
          freshGreen: freshGreen,
        ),
      ],
    );
  }
}

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color? mint;
  final Color? green;
  final Color? limeAccent;
  final Color? freshMint;
  final Color? freshGreen;

  const AppColorsExtension({
    required this.mint,
    required this.green,
    required this.limeAccent,
    required this.freshMint,
    required this.freshGreen,
  });

  @override
  AppColorsExtension copyWith({
    Color? mint,
    Color? green,
    Color? limeAccent,
    Color? freshMint,
    Color? freshGreen,
  }) {
    return AppColorsExtension(
      mint: mint ?? this.mint,
      green: green ?? this.green,
      limeAccent: limeAccent ?? this.limeAccent,
      freshMint: freshMint ?? this.freshMint,
      freshGreen: freshGreen ?? this.freshGreen,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      mint: Color.lerp(mint, other.mint, t),
      green: Color.lerp(green, other.green, t),
      limeAccent: Color.lerp(limeAccent, other.limeAccent, t),
      freshMint: Color.lerp(freshMint, other.freshMint, t),
      freshGreen: Color.lerp(freshGreen, other.freshGreen, t),
    );
  }
}

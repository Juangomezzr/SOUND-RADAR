import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF18181B),
      fontFamily: 'Roboto',
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.dark,
      ),
    );
  }
}

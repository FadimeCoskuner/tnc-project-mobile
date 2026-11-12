import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const _accent = Color(0xFF2155E5);
  static const _background = Color(0xFFF5F6F8);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: _accent, primary: _accent, surface: Colors.white);
    final radius = BorderRadius.circular(16);

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: _background,
      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: radius),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
        hintStyle: const TextStyle(color: Color(0xFF9AA0A6)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        backgroundColor: Colors.white,
        selectedColor: Colors.black,
        // Renk açıkça verilmezse yazı çevredeki rengi devralıyor ve bazı cihazlarda
        // beyaz zemin üstünde beyaz görünüyordu. Seçili çipte beyaz, diğerlerinde koyu.
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black87,
          ),
        ),
        showCheckmark: false,
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return _buildTheme(AppThemeColors.light, Brightness.light);
  }

  static ThemeData get darkTheme {
    return _buildTheme(AppThemeColors.dark, Brightness.dark);
  }

  static ThemeData _buildTheme(AppThemeColors colors, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: colors.primary,
        primary: colors.primary,
        secondary: colors.accent,
        surface: colors.cardBg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.scaffoldBg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.cardBg,
        selectedColor: colors.primary,
        labelStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.textLight),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.accent,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.cardBg,
        selectedItemColor: colors.navActive,
        unselectedItemColor: colors.navInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      fontFamily: 'Roboto',
    );
  }
}

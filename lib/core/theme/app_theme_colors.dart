import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';

class AppThemeColors {
  final Color primary;
  final Color accent;
  final Color budgetAmount;
  final Color spentAmount;
  final Color progressBackground;
  final Color progressFill;
  final Color personalTagBg;
  final Color personalTagText;
  final Color travelTagBg;
  final Color travelTagText;
  final Color otherTagBg;
  final Color otherTagText;
  final Color iconBgRed;
  final Color iconBgBlue;
  final Color iconBgGray;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLight;
  final Color scaffoldBg;
  final Color cardBg;
  final Color navInactive;
  final Color navActive;

  const AppThemeColors({
    required this.primary,
    required this.accent,
    required this.budgetAmount,
    required this.spentAmount,
    required this.progressBackground,
    required this.progressFill,
    required this.personalTagBg,
    required this.personalTagText,
    required this.travelTagBg,
    required this.travelTagText,
    required this.otherTagBg,
    required this.otherTagText,
    required this.iconBgRed,
    required this.iconBgBlue,
    required this.iconBgGray,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLight,
    required this.scaffoldBg,
    required this.cardBg,
    required this.navInactive,
    required this.navActive,
  });

  static const light = AppThemeColors(
    primary: AppColors.primary,
    accent: AppColors.accent,
    budgetAmount: AppColors.budgetAmount,
    spentAmount: AppColors.spentAmount,
    progressBackground: AppColors.progressBackground,
    progressFill: AppColors.progressFill,
    personalTagBg: AppColors.personalTagBg,
    personalTagText: AppColors.personalTagText,
    travelTagBg: AppColors.travelTagBg,
    travelTagText: AppColors.travelTagText,
    otherTagBg: AppColors.otherTagBg,
    otherTagText: AppColors.otherTagText,
    iconBgRed: AppColors.iconBgRed,
    iconBgBlue: AppColors.iconBgBlue,
    iconBgGray: AppColors.iconBgGray,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textLight: AppColors.textLight,
    scaffoldBg: AppColors.scaffoldBg,
    cardBg: AppColors.cardBg,
    navInactive: AppColors.navInactive,
    navActive: AppColors.navActive,
  );

  static const dark = AppThemeColors(
    primary: Color(0xFF7BB7D6),
    accent: AppColors.accent,
    budgetAmount: Color(0xFFEAF6FB),
    spentAmount: Color(0xFFFF8A7C),
    progressBackground: Color(0xFF263743),
    progressFill: Color(0xFFFF8A7C),
    personalTagBg: Color(0xFF4A2224),
    personalTagText: Color(0xFFFFAAA1),
    travelTagBg: Color(0xFF17394A),
    travelTagText: Color(0xFF9DDBF9),
    otherTagBg: Color(0xFF323A40),
    otherTagText: Color(0xFFCAD4DA),
    iconBgRed: Color(0xFF4A2224),
    iconBgBlue: Color(0xFF17394A),
    iconBgGray: Color(0xFF323A40),
    textPrimary: Color(0xFFEAF6FB),
    textSecondary: Color(0xFFAEC7D3),
    textLight: Color(0xFF78919E),
    scaffoldBg: Color(0xFF101820),
    cardBg: Color(0xFF18242D),
    navInactive: Color(0xFF78919E),
    navActive: Color(0xFFFF8A7C),
  );
}

extension AppThemeColorsContext on BuildContext {
  AppThemeColors get appColors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? AppThemeColors.dark
        : AppThemeColors.light;
  }
}

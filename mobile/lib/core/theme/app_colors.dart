import 'package:flutter/material.dart';

/// ForenShield Color Palette - Dark theme with Amber + Digital Teal branding
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFFFB300); // Amber
  static const Color primaryDark = Color(0xFFFF8F00);
  static const Color primaryLight = Color(0xFFFFCA28);
  static const Color secondary = Color(0xFF00BCD4); // Digital Teal
  static const Color secondaryDark = Color(0xFF0097A7);
  static const Color secondaryLight = Color(0xFF4DD0E1);

  // Background Colors (Dark Theme)
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color surfaceElevated = Color(0xFF252525);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textDisabled = Color(0xFF505050);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF29B6F6);

  // XP & Gamification
  static const Color xpGradientStart = Color(0xFFFFB300);
  static const Color xpGradientEnd = Color(0xFFFF6F00);
  static const Color streakFlame = Color(0xFFFF5722);

  // Rank Colors
  static const Color rankTrainee = Color(0xFF757575);
  static const Color rankAnalyst = Color(0xFF2196F3);
  static const Color rankInvestigator = Color(0xFF009688);
  static const Color rankSpecialist = Color(0xFFFFB300);
  static const Color rankSeniorAnalyst = Color(0xFFFF9800);
  static const Color rankExpert = Color(0xFFF44336);
  static const Color rankElite = Color(0xFFFFD700);

  // UI Elements
  static const Color divider = Color(0xFF303030);
  static const Color outline = Color(0xFF404040);
  static const Color shadow = Color(0x40000000);
  static const Color overlay = Color(0x80000000);

  // Investigation Colors
  static const Color evidenceEmail = Color(0xFF1976D2);
  static const Color evidenceBrowser = Color(0xFF7B1FA2);
  static const Color evidenceChat = Color(0xFF388E3C);
  static const Color evidenceCall = Color(0xFFF57C00);
  static const Color evidenceTransaction = Color(0xFFD32F2F);
}

import 'package:flutter/material.dart';

/// Defines the color palette for the ForenShield application.
/// Uses a dark-first cybersecurity theme with premium enterprise aesthetics.
abstract class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF00E5FF); // Cyan
  static const Color primaryDark = Color(0xFF00B8D4);
  static const Color secondary = Color(0xFF7C4DFF); // Deep Purple
  static const Color secondaryDark = Color(0xFF651FFF);
  static const Color accent = Color(0xFF39FF14); // Neon Green

  // Background & Surface (Dark Theme First)
  static const Color background = Color(0xFF0A0E17); // Deep dark blue/black
  static const Color surface = Color(0xFF151A23);
  static const Color surfaceHighlight = Color(0xFF1E2532);

  // Semantic Colors
  static const Color textPrimary = Color(0xFFF8F9FA);
  static const Color textSecondary = Color(0xFFADB5BD);
  static const Color textDisabled = Color(0xFF6C757D);
  static const Color divider = Color(0xFF2C323F);
  static const Color outline = Color(0xFF3F485B);
  static const Color surfaceVariant = Color(0xFF1E2532);
  static const Color surfaceElevated = Color(0xFF232B3A);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFF2979FF);

  // Domain Specific Colors
  static const Color investigation = Color(0xFFE040FB); // Purple for forensics
  static const Color academy = Color(0xFFFF9100); // Orange for learning
  static const Color simulation = Color(
    0xFF00E5FF,
  ); // Cyan for active simulation

  // Backwards compatibility aliases
  static const Color textTertiary = textDisabled;
  static const Color streakFlame = warning;
}

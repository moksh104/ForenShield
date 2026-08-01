import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Elevation level enum aligned with Material 3 principles.
enum ElevationLevel { low, medium, high }

/// Defines the elevation and shadow/glow system for the ForenShield application.
/// Grounded in Material 3 principles (Light mode uses drop shadows;
/// Dark mode uses minimal shadows / ambient depth overlays).
abstract class AppShadows {
  /// Material 3 Low Elevation (Level 1: Cards / Raised surfaces) - Light Mode
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x1A101820), // rgba(16, 24, 32, 0.10)
      blurRadius: 3.0,
      offset: Offset(0, 1),
    ),
  ];

  /// Material 3 Medium Elevation (Level 2: Hovered cards / Dropdowns / Popovers) - Light Mode
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1F101820), // rgba(16, 24, 32, 0.12)
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ];

  /// Material 3 High Elevation (Level 3: Dialogs / Bottom Sheets / Modals) - Light Mode
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x24101820), // rgba(16, 24, 32, 0.14)
      blurRadius: 24.0,
      offset: Offset(0, 8),
    ),
  ];

  /// Dark Mode Low Shadow (Subtle ambient depth for dark theme)
  static const List<BoxShadow> darkLow = [
    BoxShadow(
      color: Color(0x40000000), // 25% opacity black
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  /// Dark Mode Medium Shadow
  static const List<BoxShadow> darkMedium = [
    BoxShadow(
      color: Color(0x66000000), // 40% opacity black
      blurRadius: 10.0,
      offset: Offset(0, 4),
    ),
  ];

  /// Dark Mode High Shadow
  static const List<BoxShadow> darkHigh = [
    BoxShadow(
      color: Color(0x80000000), // 50% opacity black
      blurRadius: 20.0,
      offset: Offset(0, 8),
    ),
  ];

  /// Dynamic shadow lookup respecting light/dark theme and M3 elevation level
  static List<BoxShadow> forBrightness({
    required Brightness brightness,
    required ElevationLevel level,
  }) {
    final isDark = brightness == Brightness.dark;
    switch (level) {
      case ElevationLevel.low:
        return isDark ? darkLow : low;
      case ElevationLevel.medium:
        return isDark ? darkMedium : medium;
      case ElevationLevel.high:
        return isDark ? darkHigh : high;
    }
  }

  // Backwards compatibility aliases
  static const List<BoxShadow> none = [];
  static const List<BoxShadow> subtle = low;
  static const List<BoxShadow> small = low;
  static const List<BoxShadow> large = high;

  /// Cyber glow effect using primary color
  static List<BoxShadow> cyberGlowPrimary = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      blurRadius: 12.0,
      spreadRadius: 2.0,
      offset: Offset.zero,
    ),
  ];

  /// Cyber glow effect using secondary color
  static List<BoxShadow> cyberGlowSecondary = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.3),
      blurRadius: 12.0,
      spreadRadius: 2.0,
      offset: Offset.zero,
    ),
  ];

  /// Cyber glow effect for critical/alert states
  static List<BoxShadow> cyberGlowError = [
    BoxShadow(
      color: AppColors.error.withValues(alpha: 0.4),
      blurRadius: 12.0,
      spreadRadius: 2.0,
      offset: Offset.zero,
    ),
  ];
}

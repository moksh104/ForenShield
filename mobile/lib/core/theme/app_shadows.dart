import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Elevation level enum aligned with Material 3 principles.
enum ElevationLevel { low, medium, high }

/// Defines the shadow system for ForenShield (Phase 2 UI Optimization).
/// Single source of truth for drop shadows (offsetY = 4, blurRadius = 12, opacity = 0.08).
abstract class AppShadows {
  /// Base shadow conforming to Phase 2 specs: offsetY = 4, blurRadius = 12, opacity = 0.08
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color(0x140F172A), // 0x14 ≈ 0.08 opacity (20/255)
    blurRadius: 12.0,
    offset: Offset(0, 4),
  );

  /// Low Elevation (Level 1: Cards / Raised surfaces) - Light Mode
  static const List<BoxShadow> low = [
    BoxShadow(color: Color(0x140F172A), blurRadius: 12.0, offset: Offset(0, 4)),
  ];

  /// Medium Elevation (Level 2: Hovered cards / Dropdowns / Popovers) - Light Mode
  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x140F172A), blurRadius: 12.0, offset: Offset(0, 4)),
  ];

  /// High Elevation (Level 3: Dialogs / Bottom Sheets / Modals) - Light Mode
  static const List<BoxShadow> high = [
    BoxShadow(color: Color(0x140F172A), blurRadius: 12.0, offset: Offset(0, 4)),
  ];

  /// Dark Mode Low Shadow (Subtle ambient depth with opacity 0.08)
  static const List<BoxShadow> darkLow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 12.0, offset: Offset(0, 4)),
  ];

  /// Dark Mode Medium Shadow
  static const List<BoxShadow> darkMedium = [
    BoxShadow(color: Color(0x14000000), blurRadius: 12.0, offset: Offset(0, 4)),
  ];

  /// Dark Mode High Shadow
  static const List<BoxShadow> darkHigh = [
    BoxShadow(color: Color(0x14000000), blurRadius: 12.0, offset: Offset(0, 4)),
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

  /// Soft accent focus shadow using single primary Cobalt Blue with opacity 0.08
  static List<BoxShadow> cyberGlowPrimary = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 12.0,
      spreadRadius: 0.0,
      offset: const Offset(0, 4),
    ),
  ];

  /// Soft accent shadow
  static List<BoxShadow> cyberGlowSecondary = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.08),
      blurRadius: 12.0,
      spreadRadius: 0.0,
      offset: const Offset(0, 4),
    ),
  ];

  /// Soft alert shadow
  static List<BoxShadow> cyberGlowError = [
    BoxShadow(
      color: AppColors.error.withValues(alpha: 0.08),
      blurRadius: 12.0,
      spreadRadius: 0.0,
      offset: const Offset(0, 4),
    ),
  ];
}

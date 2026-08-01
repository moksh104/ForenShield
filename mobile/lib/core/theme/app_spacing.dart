import 'package:flutter/material.dart';

/// Defines the spacing scale for the ForenShield application.
/// Ensures consistent margins and paddings across the app without magic numbers.
abstract class AppSpacing {
  /// 4.0 pixels
  static const double xxs = 4.0;

  /// 8.0 pixels
  static const double xs = 8.0;

  /// 12.0 pixels
  static const double sm = 12.0;

  /// 16.0 pixels (Base spacing)
  static const double md = 16.0;

  /// 24.0 pixels
  static const double lg = 24.0;

  /// 32.0 pixels
  static const double xl = 32.0;

  /// 40.0 pixels
  static const double xxl = 40.0;

  /// 48.0 pixels
  static const double xxxl = 48.0;

  /// 64.0 pixels
  static const double huge = 64.0;

  // Semantic padding constants
  static const EdgeInsets pagePadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const EdgeInsets dialogPadding = EdgeInsets.all(xl);
}

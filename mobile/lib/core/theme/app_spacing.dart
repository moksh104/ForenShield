import 'package:flutter/material.dart';

/// Defines the spacing scale for the ForenShield application (Phase 2 UI Optimization).
/// Single source of truth for all spacing tokens.
abstract class AppSpacing {
  /// 4.0 pixels
  static const double xs = 4.0;

  /// 8.0 pixels
  static const double sm = 8.0;

  /// 12.0 pixels
  static const double md = 12.0;

  /// 16.0 pixels
  static const double lg = 16.0;

  /// 24.0 pixels
  static const double xl = 24.0;

  /// 32.0 pixels
  static const double xxl = 32.0;

  /// 4.0 pixels (backwards compatibility alias)
  static const double xxs = xs;

  /// 48.0 pixels (backwards compatibility alias)
  static const double xxxl = 48.0;

  /// 64.0 pixels (backwards compatibility alias)
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

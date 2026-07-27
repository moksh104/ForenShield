import 'package:flutter/material.dart';

/// Defines the border radius scale for the ForenShield application.
/// Consistent rounding for cards, dialogs, buttons, and other components.
abstract class AppRadius {
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

  /// Circular radius for fully rounded elements like pills or avatars
  static const double circular = 999.0;

  // Pre-defined BorderRadius objects for convenience
  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(xs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(sm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(md),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(lg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(xl),
  );
  static const BorderRadius borderRadiusXxl = BorderRadius.all(
    Radius.circular(xxl),
  );
  static const BorderRadius borderRadiusCircular = BorderRadius.all(
    Radius.circular(circular),
  );

  // Backwards compatibility aliases
  static const BorderRadius borderMd = borderRadiusMd;
  static const BorderRadius borderPill = borderRadiusCircular;
  static const BorderRadius borderLg = borderRadiusLg;
}

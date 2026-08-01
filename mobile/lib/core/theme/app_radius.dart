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

  // Named semantic double constants
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
  static const double pill = 999.0;

  // Semantic component BorderRadius objects
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(large),
  );
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(medium),
  );
  static const BorderRadius sheetRadius = BorderRadius.all(
    Radius.circular(extraLarge),
  );
  static const BorderRadius dialogRadius = BorderRadius.all(
    Radius.circular(extraLarge),
  );

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

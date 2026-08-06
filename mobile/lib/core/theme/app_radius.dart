import 'package:flutter/material.dart';

/// Defines the border radius scale for the ForenShield application (Phase 2 UI Optimization).
/// Single source of truth for all radius & card shape tokens (Card radius: 12, 16, 20).
abstract class AppRadius {
  /// 4.0 pixels
  static const double xs = 4.0;

  /// 8.0 pixels
  static const double sm = 8.0;

  /// 12.0 pixels
  static const double md = 12.0;

  /// 16.0 pixels
  static const double lg = 16.0;

  /// 20.0 pixels
  static const double xl = 20.0;

  /// 32.0 pixels
  static const double xxl = 32.0;

  /// Circular radius for fully rounded elements like pills or avatars
  static const double circular = 999.0;

  // Card Radius Scale: 12, 16, 20
  static const double cardSmall = 12.0;
  static const double cardMedium = 16.0;
  static const double cardLarge = 20.0;
  static const double card = 16.0;

  // Named semantic double constants
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
  static const double pill = 999.0;

  // Semantic component ShapeBorders (Squircles)
  static final ShapeBorder cardShape = ContinuousRectangleBorder(
    borderRadius: BorderRadius.circular(cardMedium),
  );
  static final ShapeBorder buttonShape = ContinuousRectangleBorder(
    borderRadius: BorderRadius.circular(small),
  );
  static final ShapeBorder sheetShape = ContinuousRectangleBorder(
    borderRadius: BorderRadius.circular(large),
  );
  static final ShapeBorder dialogShape = ContinuousRectangleBorder(
    borderRadius: BorderRadius.circular(large),
  );

  // Fallback standard BorderRadius objects
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

  static const BorderRadius cardRadiusSmall = BorderRadius.all(
    Radius.circular(cardSmall),
  );
  static const BorderRadius cardRadiusMedium = BorderRadius.all(
    Radius.circular(cardMedium),
  );
  static const BorderRadius cardRadiusLarge = BorderRadius.all(
    Radius.circular(cardLarge),
  );
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(cardMedium),
  );
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(small),
  );
  static const BorderRadius sheetRadius = BorderRadius.all(
    Radius.circular(large),
  );
  static const BorderRadius dialogRadius = BorderRadius.all(
    Radius.circular(large),
  );
}

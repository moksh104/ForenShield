/// ForenShield Design System v1.0 — Foundation Tokens
///
/// Single source of truth for every raw value used in the theme.
/// Do not hardcode a color, spacing, radius, or duration anywhere
/// outside this file — reference the token instead.
library;

import 'package:flutter/material.dart';

// ============================================================
// 1. COLOR — Neutral Scale
// ============================================================

class ForenNeutralDark {
  ForenNeutralDark._();
  static const bgBase = Color(0xFF0A0E14);
  static const bgSurface = Color(0xFF0F1620);
  static const bgSurfaceRaised1 = Color(0xFF141C28);
  static const bgSurfaceRaised2 = Color(0xFF1B2531);
  static const bgSurfaceRaised3 = Color(0xFF24303D);
  static const borderSubtle = Color(0xFF232E3B);
  static const borderDefault = Color(0xFF374557);
  static const textPrimary = Color(0xFFE8EDF2);
  static const textSecondary = Color(0xFFA9B4C0);
  static const textDisabled = Color(0xFF5C6773);
}

class ForenNeutralLight {
  ForenNeutralLight._();
  static const bgBase = Color(0xFFF5F7FA);
  static const bgSurface = Color(0xFFFFFFFF);
  static const bgSurfaceRaised1 = Color(0xFFF0F3F7);
  static const bgSurfaceRaised2 = Color(0xFFE7ECF1);
  static const bgSurfaceRaised3 = Color(0xFFFFFFFF);
  static const borderSubtle = Color(0xFFE1E6EC);
  static const borderDefault = Color(0xFFC7D0DA);
  static const textPrimary = Color(0xFF111820);
  static const textSecondary = Color(0xFF48545F);
  static const textDisabled = Color(0xFF9AA4AE);
}

// ============================================================
// 2. COLOR — Feature Accent Ramps (300 / 500 / 700)
// ============================================================

@immutable
class ForenAccentRamp {
  final Color t300;
  final Color t500;
  final Color t700;
  const ForenAccentRamp({
    required this.t300,
    required this.t500,
    required this.t700,
  });
}

class ForenFeatureColors {
  ForenFeatureColors._();

  /// Mission Control — Cyan — Control Center
  static const missionControl = ForenAccentRamp(
    t300: Color(0xFF67E8F9),
    t500: Color(0xFF06B6D4),
    t700: Color(0xFF0E7490),
  );

  /// Academy — Amber — Learning
  static const academy = ForenAccentRamp(
    t300: Color(0xFFFCD34D),
    t500: Color(0xFFF59E0B),
    t700: Color(0xFFB45309),
  );

  /// Investigation — Purple — Evidence
  static const investigation = ForenAccentRamp(
    t300: Color(0xFFC4B5FD),
    t500: Color(0xFF8B5CF6),
    t700: Color(0xFF6D28D9),
  );

  /// Simulation — Green — Practice
  static const simulation = ForenAccentRamp(
    t300: Color(0xFF86EFAC),
    t500: Color(0xFF22C55E),
    t700: Color(0xFF15803D),
  );

  /// Profile — Blue — Personal Growth
  static const profile = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF3B82F6),
    t700: Color(0xFF1D4ED8),
  );
}

// ============================================================
// 3. COLOR — Semantic / Status
// ============================================================
// Deliberately distinct hues from the feature accents above.
// RULE: semantic colors are for small contexts only (badges,
// borders, alert bars, list icons) — never full-surface fills.

class ForenSemanticColors {
  ForenSemanticColors._();

  static const success = ForenAccentRamp(
    t300: Color(0xFF4ADE80),
    t500: Color(0xFF16A34A),
    t700: Color(0xFF166534),
  );

  static const warning = ForenAccentRamp(
    t300: Color(0xFFFDBA74),
    t500: Color(0xFFF97316),
    t700: Color(0xFFC2410C),
  );

  static const critical = ForenAccentRamp(
    t300: Color(0xFFFCA5A5),
    t500: Color(0xFFEF4444),
    t700: Color(0xFFB91C1C),
  );

  static const info = ForenAccentRamp(
    t300: Color(0xFF7DD3FC),
    t500: Color(0xFF0EA5E9),
    t700: Color(0xFF0369A1),
  );
}

/// Which accent belongs to which pillar. Use this instead of
/// referencing ForenFeatureColors directly in screen code, so a
/// future rename/re-theme only happens in one place.
enum ForenFeature { missionControl, academy, investigation, simulation, profile }

extension ForenFeatureColorLookup on ForenFeature {
  ForenAccentRamp get ramp {
    switch (this) {
      case ForenFeature.missionControl:
        return ForenFeatureColors.missionControl;
      case ForenFeature.academy:
        return ForenFeatureColors.academy;
      case ForenFeature.investigation:
        return ForenFeatureColors.investigation;
      case ForenFeature.simulation:
        return ForenFeatureColors.simulation;
      case ForenFeature.profile:
        return ForenFeatureColors.profile;
    }
  }
}

// ============================================================
// 4. SPACING — 8pt grid (4 as half-step). Only these exist.
// ============================================================

class ForenSpace {
  ForenSpace._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

// ============================================================
// 5. RADIUS
// ============================================================

class ForenRadius {
  ForenRadius._();
  static const double button = 16;
  static const double input = 16; // matches button, no separate value
  static const double card = 20;
  static const double dialog = 24;
  static const double image = 18;
  static const double pill = 999;

  static BorderRadius get buttonBr => BorderRadius.circular(button);
  static BorderRadius get cardBr => BorderRadius.circular(card);
  static BorderRadius get dialogBr => BorderRadius.circular(dialog);
  static BorderRadius get imageBr => BorderRadius.circular(image);
  static BorderRadius get pillBr => BorderRadius.circular(pill);
}

// ============================================================
// 6. ELEVATION — dp levels. Dark = surface tint, Light = shadow.
// ============================================================

class ForenElevation {
  ForenElevation._();
  static const double level0 = 0; // base page
  static const double level1 = 2; // cards (default)
  static const double level2 = 4; // dropdowns, popovers, hovered card
  static const double level3 = 8; // dialogs, modals, sheets

  static List<BoxShadow> lightShadow(double level) {
    if (level <= level0) return const [];
    if (level <= level1) {
      return [
        BoxShadow(
          color: const Color(0xFF101820).withValues(alpha: 0.08),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];
    }
    if (level <= level2) {
      return [
        BoxShadow(
          color: const Color(0xFF101820).withValues(alpha: 0.10),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [
      BoxShadow(
        color: const Color(0xFF101820).withValues(alpha: 0.14),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }
}

// ============================================================
// 7. BORDERS
// ============================================================

class ForenBorderWidth {
  ForenBorderWidth._();
  static const double hairline = 1;
  static const double defaultWidth = 1;
  static const double focus = 2;
  static const double error = 1.5;
}

// ============================================================
// 8. ICON SIZES
// ============================================================

class ForenIconSize {
  ForenIconSize._();
  static const double compact = 20;
  static const double defaultSize = 24;
  static const double hero = 32;
}

// ============================================================
// 9. MOTION
// ============================================================

class ForenMotionDuration {
  ForenMotionDuration._();
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration emphasis = Duration(milliseconds: 600);
}

class ForenMotionCurve {
  ForenMotionCurve._();
  static const Curve micro = Curves.easeOut;
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve emphasis = Curves.easeOutBack; // spring-like emphasis
}

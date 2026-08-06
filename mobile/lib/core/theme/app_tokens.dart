/// ForenShield Design System v2.0 — Enterprise Tokens
///
/// Single source of truth for raw values used across the application.
/// Grounded in Mobbin specs (Linear, Notion, GitHub, Stripe):
/// Single primary accent color (Cobalt #2563EB), generous spacing (24-32px margins),
/// readable typography, soft continuous rounded corners (12-16px).
library;

import 'package:flutter/material.dart';

// ============================================================
// 1. COLOR — Neutral Scale
// ============================================================

class ForenNeutralDark {
  ForenNeutralDark._();
  static const bgBase = Color(0xFF0B1220); // Dark navy base
  static const bgSurface = Color(0xFF0F172A); // Elevated slate surface
  static const bgSurfaceRaised1 = Color(0xFF1E293B);
  static const bgSurfaceRaised2 = Color(0xFF334155);
  static const bgSurfaceRaised3 = Color(0xFF475569);
  static const borderSubtle = Color(0xFF1E293B);
  static const borderDefault = Color(0xFF334155);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textDisabled = Color(0xFF64748B);
}

class ForenNeutralLight {
  ForenNeutralLight._();
  static const bgBase = Color(0xFFF8FAFC); // Clean off-white page background
  static const bgSurface = Color(0xFFFFFFFF); // Pure white surface cards
  static const bgSurfaceRaised1 = Color(0xFFF1F5F9);
  static const bgSurfaceRaised2 = Color(0xFFE2E8F0);
  static const bgSurfaceRaised3 = Color(0xFFFFFFFF);
  static const borderSubtle = Color(0xFFF1F5F9);
  static const borderDefault = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textDisabled = Color(0xFF94A3B8);
}

// ============================================================
// 2. COLOR — Feature Accent Ramps (Single Primary Cobalt Accent)
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

  /// Mission Control — Cobalt Blue (#2563EB)
  static const missionControl = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF2563EB),
    t700: Color(0xFF1D4ED8),
  );

  /// Academy — Cobalt Blue (#2563EB)
  static const academy = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF2563EB),
    t700: Color(0xFF1D4ED8),
  );

  /// Investigation — Cobalt Blue (#2563EB)
  static const investigation = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF2563EB),
    t700: Color(0xFF1D4ED8),
  );

  /// Simulation — Cobalt Blue (#2563EB)
  static const simulation = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF2563EB),
    t700: Color(0xFF1D4ED8),
  );

  /// Profile — Cobalt Blue (#2563EB)
  static const profile = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF2563EB),
    t700: Color(0xFF1D4ED8),
  );
}

// ============================================================
// 3. COLOR — Semantic / Status
// ============================================================

class ForenSemanticColors {
  ForenSemanticColors._();

  static const success = ForenAccentRamp(
    t300: Color(0xFF6EE7B7),
    t500: Color(0xFF10B981),
    t700: Color(0xFF047857),
  );

  static const warning = ForenAccentRamp(
    t300: Color(0xFDFCD34D),
    t500: Color(0xFFF59E0B),
    t700: Color(0xFFB45309),
  );

  static const critical = ForenAccentRamp(
    t300: Color(0xFFFCA5A5),
    t500: Color(0xFFEF4444),
    t700: Color(0xFFB91C1C),
  );

  static const info = ForenAccentRamp(
    t300: Color(0xFF93C5FD),
    t500: Color(0xFF3B82F6),
    t700: Color(0xFF1D4ED8),
  );
}

enum ForenFeature {
  missionControl,
  academy,
  investigation,
  simulation,
  profile,
}

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
// ============================================================
// 4. SPACING — Phase 2 UI Specs (xs=4, sm=8, md=12, lg=16, xl=24, xxl=32)
// ============================================================

class ForenSpace {
  ForenSpace._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

// ============================================================
// 5. RADIUS — Card radius scale (12, 16, 20)
// ============================================================

class ForenRadius {
  ForenRadius._();
  static const double button = 12;
  static const double input = 12;
  static const double cardSmall = 12;
  static const double cardMedium = 16;
  static const double cardLarge = 20;
  static const double card = 16;
  static const double dialog = 20;
  static const double image = 14;
  static const double pill = 999;

  static BorderRadius get buttonBr => BorderRadius.circular(button);
  static BorderRadius get cardBr => BorderRadius.circular(card);
  static BorderRadius get dialogBr => BorderRadius.circular(dialog);
  static BorderRadius get imageBr => BorderRadius.circular(image);
  static BorderRadius get pillBr => BorderRadius.circular(pill);

  static ShapeBorder get buttonShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(button));
  static ShapeBorder get cardShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(card));
  static ShapeBorder get dialogShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(dialog));
  static ShapeBorder get pillShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(pill));
}

// ============================================================
// 6. ELEVATION — Phase 2 Drop Shadows (offsetY=4, blurRadius=12, opacity=0.08)
// ============================================================

class ForenElevation {
  ForenElevation._();
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 2;
  static const double level3 = 4;

  static List<BoxShadow> lightShadow(double level) {
    if (level <= level0) return const [];
    return [
      const BoxShadow(
        color: Color(0x140F172A),
        blurRadius: 12,
        offset: Offset(0, 4),
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
// 9. MOTION — Phase 2 scale (150ms, 200ms, 250ms, 300ms)
// ============================================================

class ForenMotionDuration {
  ForenMotionDuration._();
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration emphasis = Duration(milliseconds: 300);
}

class ForenMotionCurve {
  ForenMotionCurve._();
  static const Curve micro = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve emphasis = Curves.easeOutBack;
}

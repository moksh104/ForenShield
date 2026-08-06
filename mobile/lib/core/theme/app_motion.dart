import 'package:flutter/material.dart';

/// Centralized motion tokens for ForenShield (Phase 2 UI Optimization).
/// Single source of truth for all animation timing and easing.
/// Strictly configured to Phase 2 scale: 150 ms, 200 ms, 250 ms, 300 ms.
class AppMotion {
  AppMotion._();

  // ------------------------------------
  // Animation Durations (150ms, 200ms, 250ms, 300ms)
  // ------------------------------------

  /// 0ms - Instant change
  static const Duration instant = Duration.zero;

  /// 150ms - Micro-interactions, ripples, quick toggles
  static const Duration microDuration = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 150);

  /// 200ms - Standard transitions, hover states, selection shifts
  static const Duration normal = Duration(milliseconds: 200);

  /// 250ms - Card expands, page transitions, sheets
  static const Duration medium = Duration(milliseconds: 250);

  /// 300ms - Dialog appearances, major state transitions
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration slower = Duration(milliseconds: 300);

  // ------------------------------------
  // Animation Curves
  // ------------------------------------

  /// Fade curve - smooth opacity transition
  static const Curve fade = Curves.easeOutCirc;

  /// Scale curve - spring/overshoot scale transition
  static const Curve scale = Curves.easeOutBack;

  /// Slide curve - natural position slide transition
  static const Curve slide = Curves.easeInOutBack;

  /// Bounce curve - energetic bounce effect
  static const Curve bounce = Curves.bounceOut;

  /// Standard easing for generic movement
  static const Curve standard = Curves.easeInOut;

  /// Easing for elements entering the screen
  static const Curve decelerate = Curves.easeOutCubic;

  /// Easing for elements exiting the screen
  static const Curve accelerate = Curves.easeInCubic;

  /// Dramatic easing for major transitions
  static const Curve emphasized = Curves.easeOutCubic;

  /// Elastic spring easing
  static const Curve elastic = Curves.elasticOut;

  /// Micro-interaction easing
  static const Curve micro = Curves.easeOutCirc;

  // ------------------------------------
  // Animation Delays (Staggers)
  // ------------------------------------

  /// 50ms stagger
  static const Duration stagger1 = Duration(milliseconds: 50);

  /// 100ms stagger
  static const Duration stagger2 = Duration(milliseconds: 100);

  /// 150ms stagger
  static const Duration stagger3 = Duration(milliseconds: 150);

  /// 200ms stagger
  static const Duration stagger4 = Duration(milliseconds: 200);

  // ------------------------------------
  // Helper Extensions
  // ------------------------------------

  /// Standard duration for opacity fades (150ms)
  static const Duration fadeDuration = fast;

  /// Standard duration for full page transitions (250ms)
  static const Duration pageTransition = medium;

  /// Standard duration for dialog/modal appearances (200ms)
  static const Duration dialogTransition = normal;
}

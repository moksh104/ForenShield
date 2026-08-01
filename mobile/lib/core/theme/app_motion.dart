import 'package:flutter/material.dart';

/// Centralized motion tokens for ForenShield.
/// Acts as the single source of truth for all animation timing and easing.
class AppMotion {
  AppMotion._();

  // ------------------------------------
  // Animation Durations
  // ------------------------------------

  /// 0ms - Instant change
  static const Duration instant = Duration.zero;

  /// 150ms - Micro-interactions, hover states, ripples
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms - Standard transitions, expansions
  static const Duration normal = Duration(milliseconds: 250);

  /// 500ms - Emphasized celebrations, complex state changes
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms - Ambient animations, heavy emphasis
  static const Duration slower = Duration(milliseconds: 800);

  // ------------------------------------
  // Animation Curves
  // ------------------------------------

  /// Fade curve - smooth opacity transition
  static const Curve fade = Curves.easeOut;

  /// Scale curve - spring/overshoot scale transition
  static const Curve scale = Curves.easeOutBack;

  /// Slide curve - natural position slide transition
  static const Curve slide = Curves.easeInOutCubic;

  /// Bounce curve - energetic bounce effect
  static const Curve bounce = Curves.bounceOut;

  /// Standard easing for generic movement
  static const Curve standard = Curves.easeInOut;

  /// Easing for elements entering the screen (starts fast, ends slow)
  static const Curve decelerate = Curves.easeOut;

  /// Easing for elements exiting the screen (starts slow, ends fast)
  static const Curve accelerate = Curves.easeIn;

  /// Dramatic easing for major transitions
  static const Curve emphasized = Curves.easeInOutCubic;

  /// Elastic spring easing
  static const Curve elastic = Curves.elasticOut;

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

  /// Standard duration for opacity fades
  static const Duration fadeDuration = fast;

  /// Standard duration for full page transitions
  static const Duration pageTransition = normal;

  /// Standard duration for dialog/modal appearances
  static const Duration dialogTransition = normal;
}

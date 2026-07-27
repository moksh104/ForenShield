import 'package:flutter/animation.dart';
import '../../../../core/theme/app_motion.dart';

/// Single source of truth for every animation timing constant in the
/// ForenShield onboarding flow.
///
/// All onboarding pages reference these values instead of declaring
/// durations locally. To adjust the overall feel of the flow, edit
/// only this file.
class OnboardingAnimationConfig {
  OnboardingAnimationConfig._();

  // ── Illustration Entry ─────────────────────────────────────────────────────

  /// Duration of the one-shot illustration entry controller.
  /// Used by shield scale, console ring, and equivalent hero elements.
  static const Duration entryDuration = AppMotion.slower; // 800ms

  /// Delay after page mount before the illustration entry starts.
  static const Duration illustrationEntryDelay = AppMotion.stagger4; // 200ms

  // ── Looping Animations ─────────────────────────────────────────────────────

  /// Duration of one full radar ring expansion cycle (Screen 1).
  static const Duration radarDuration = Duration(milliseconds: 2000);

  /// Duration of one full scan line sweep cycle (Screen 2).
  static const Duration scanLineDuration = Duration(milliseconds: 3000);

  /// Duration of the ambient particle field loop (all screens).
  static const Duration particleDuration = Duration(seconds: 10);

  // ── Page Navigation ────────────────────────────────────────────────────────

  /// Duration for PageController.animateToPage().
  static const Duration pageTransitionDuration = AppMotion.normal; // 300ms

  /// Easing curve for all page transitions.
  static const Curve pageCurve = AppMotion.emphasized; // easeInOutCubic

  // ── Text Entry ─────────────────────────────────────────────────────────────

  /// Duration for category label, headline and caption fade+slide.
  static const Duration textEntryDuration = AppMotion.slow; // 500ms

  /// Duration for individual supporting line fade animations.
  static const Duration textLineDuration = AppMotion.normal; // 300ms

  // ── Text Stagger Delays ────────────────────────────────────────────────────

  /// Delay before the category label fades in.
  static const Duration categoryLabelDelay = Duration(milliseconds: 380);

  /// Delay before the headline fades in.
  static const Duration headlineDelay = Duration(milliseconds: 560);

  /// Delay before supporting line 1 fades in.
  static const Duration line1Delay = Duration(milliseconds: 740);

  /// Delay before supporting line 2 fades in.
  static const Duration line2Delay = Duration(milliseconds: 860);

  /// Delay before supporting line 3 fades in.
  static const Duration line3Delay = Duration(milliseconds: 980);

  /// Delay before supporting line 4 fades in (4-line screens only).
  static const Duration line4Delay = Duration(milliseconds: 1060);

  /// Delay before the bottom caption fades in.
  static const Duration captionDelay = Duration(milliseconds: 1150);
}

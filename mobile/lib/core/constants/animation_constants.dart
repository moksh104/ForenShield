import 'package:flutter/material.dart';

/// Centralized animation durations for ForenShield.
/// Note: These act as explicit tokens for generic animations. For component-specific
/// motion tokens, prefer `AppMotion` from the design system.
class AnimationConstants {
  AnimationConstants._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve decelerationCurve = Curves.easeOut;
  static const Curve accelerationCurve = Curves.easeIn;
}

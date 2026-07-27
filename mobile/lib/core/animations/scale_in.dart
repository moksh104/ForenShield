import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// A reusable scale-in animation.
/// Perfect for badges, floating action buttons, and popups.
class ScaleIn extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration of the scale. Defaults to [AppMotion.normal].
  final Duration? duration;

  /// The delay before the animation starts. Defaults to [Duration.zero].
  final Duration? delay;

  /// The curve of the animation. Defaults to [AppMotion.emphasized] or bounce.
  final Curve? curve;

  /// The starting scale ratio. Defaults to 0.8.
  final double begin;

  /// Whether to fade in alongside the scale. Defaults to true.
  final bool fade;

  const ScaleIn({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.begin = 0.8,
    this.fade = true,
  });

  @override
  Widget build(BuildContext context) {
    var animation = child
        .animate(delay: delay)
        .scale(
          begin: Offset(begin, begin),
          end: const Offset(1.0, 1.0),
          duration: duration ?? AppMotion.normal,
          curve: curve ?? AppMotion.emphasized,
        );

    if (fade) {
      animation = animation.fadeIn(
        duration: duration ?? AppMotion.normal,
        curve: curve ?? AppMotion.standard,
      );
    }

    return animation;
  }
}

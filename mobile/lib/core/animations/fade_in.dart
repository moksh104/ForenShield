import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// A reusable, performance-optimized fade-in animation.
/// Uses implicit animation logic via flutter_animate to prevent state bloat.
class FadeIn extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration of the fade. Defaults to [AppMotion.normal].
  final Duration? duration;

  /// The delay before the animation starts. Defaults to [Duration.zero].
  final Duration? delay;

  /// The curve of the animation. Defaults to [AppMotion.standard].
  final Curve? curve;

  const FadeIn({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(
          duration: duration ?? AppMotion.normal,
          curve: curve ?? AppMotion.standard,
        );
  }
}

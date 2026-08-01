import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// Reusable, performance-optimized generic FadeAnimation component.
/// Uses flutter_animate with AppMotion duration and curve tokens.
class FadeAnimation extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration of the fade. Defaults to [AppMotion.normal].
  final Duration? duration;

  /// The delay before the animation starts. Defaults to [Duration.zero].
  final Duration? delay;

  /// The curve of the animation. Defaults to [AppMotion.fade].
  final Curve? curve;

  /// Starting opacity. Defaults to 0.0.
  final double begin;

  /// Ending opacity. Defaults to 1.0.
  final double end;

  const FadeAnimation({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(
          begin: begin,
          duration: duration ?? AppMotion.normal,
          curve: curve ?? AppMotion.fade,
        );
  }
}

/// Backwards compatibility alias for FadeIn
typedef FadeIn = FadeAnimation;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_motion.dart';

/// Reusable generic ScaleAnimation component.
/// Uses flutter_animate with AppMotion duration and curve tokens.
class ScaleAnimation extends StatelessWidget {
  /// The widget to animate.
  final Widget child;

  /// The duration of the scale. Defaults to [AppMotion.normal].
  final Duration? duration;

  /// The delay before the animation starts. Defaults to [Duration.zero].
  final Duration? delay;

  /// The curve of the animation. Defaults to [AppMotion.scale].
  final Curve? curve;

  /// The starting scale ratio. Defaults to 0.8.
  final double begin;

  /// The ending scale ratio. Defaults to 1.0.
  final double end;

  /// Whether to cross-fade while scaling. Defaults to true.
  final bool fade;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.begin = 0.8,
    this.end = 1.0,
    this.fade = true,
  });

  @override
  Widget build(BuildContext context) {
    var animation = child
        .animate(delay: delay)
        .scale(
          begin: Offset(begin, begin),
          end: Offset(end, end),
          duration: duration ?? AppMotion.normal,
          curve: curve ?? AppMotion.scale,
        );

    if (fade) {
      animation = animation.fadeIn(
        duration: duration ?? AppMotion.normal,
        curve: curve ?? AppMotion.fade,
      );
    }

    return animation;
  }
}

/// Backwards compatibility alias for ScaleIn
typedef ScaleIn = ScaleAnimation;

import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

/// A wrapper for the standard Flutter Hero widget.
/// Enforces ForenShield's Design System motion tokens onto the flight transition.
class HeroTransition extends StatelessWidget {
  /// The unique hero tag.
  final String tag;

  /// The hero content widget.
  final Widget child;

  /// Whether to cross-fade the shuttle element during flight. Defaults to true.
  final bool enableFade;

  const HeroTransition({
    super.key,
    required this.tag,
    required this.child,
    this.enableFade = true,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder:
          (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final Widget toHero = toHeroContext.widget;

            if (!enableFade) return toHero;

            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).chain(CurveTween(curve: AppMotion.standard)),
              ),
              child: toHero,
            );
          },
      child: child,
    );
  }
}

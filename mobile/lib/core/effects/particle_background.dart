import 'package:flutter/material.dart';

/// Clean background wrapper adhering to Mobbin design principles.
/// Replaces sci-fi particle animations with clean, distraction-free whitespace.
class ParticleBackground extends StatelessWidget {
  final Widget? child;
  final int numberOfParticles;
  final Color? particleColor;
  final Duration duration;

  const ParticleBackground({
    super.key,
    this.child,
    this.numberOfParticles = 25,
    this.particleColor,
    this.duration = const Duration(seconds: 15),
  });

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox.shrink();
  }
}

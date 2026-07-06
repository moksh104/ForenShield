import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo container with ambient glow
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC98A2E).withValues(alpha: 0.15),
                blurRadius: 60,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: const Color(0xFF0F766E).withValues(alpha: 0.08),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A202C),
              border: Border.all(
                color: const Color(0xFFC98A2E).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 60,
              color: Color(0xFFC98A2E),
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: 600.ms),
        
        const SizedBox(height: 24),
        
        // App name
        const Text(
          'ForenShield',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF5F5F4),
            letterSpacing: 1.2,
            fontFamily: 'Geist',
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
        
        const SizedBox(height: 8),
        
        // Tagline
        const Text(
          'Learn. Investigate. Defend.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF94A3B8),
            letterSpacing: 0.8,
            fontFamily: 'Geist',
          ),
        )
            .animate(delay: 600.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
      ],
    );
  }
}

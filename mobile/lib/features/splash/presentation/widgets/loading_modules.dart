import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../pages/splash_screen.dart';

/// Cybersecurity Module Initialization checklist displaying telemetry status during splash loading.
class LoadingModules extends StatelessWidget {
  const LoadingModules({super.key});

  @override
  Widget build(BuildContext context) {
    const modules = [
      '01. MISSION CONTROL LINK',
      '02. CYBER THREAT MATRIX',
      '03. SIMULATION LAB CORE',
      '04. FORENSIC EVIDENCE ENGINE',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        modules.length,
        (index) => _ModuleItem(
          name: modules[index],
          delay: Duration(milliseconds: 600 + (index * 180)),
        ),
      ),
    );
  }
}

class _ModuleItem extends StatelessWidget {
  final String name;
  final Duration delay;

  const _ModuleItem({
    required this.name,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    final Widget iconBox = Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.logoTeal.withValues(alpha: 0.15),
        border: Border.all(
          color: AppColors.logoTeal,
          width: 1.2,
        ),
      ),
      child: const Icon(
        Icons.check,
        size: 10,
        color: AppColors.logoTeal,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkmark icon with GlowEffect switch check
          Animate(
            delay: delay,
            child: SplashScreen.enableAdvancedEffects
                ? GlowEffect(
                    glowColor: AppColors.logoTeal,
                    blurRadius: 6,
                    spreadRadius: 1,
                    animate: true,
                    borderRadius: BorderRadius.circular(10),
                    child: iconBox,
                  )
                : iconBox,
          )
              .fadeIn(duration: 250.ms)
              .scale(begin: const Offset(0.5, 0.5)),

          const SizedBox(width: AppSpacing.sm),

          // Module name
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: foren.textSecondary,
              fontFamily: 'monospace',
              letterSpacing: 0.5,
            ),
          )
              .animate(delay: delay)
              .fadeIn(duration: 250.ms)
              .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }
}

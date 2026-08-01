import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../pages/splash_screen.dart';

/// Animated ForenShield logo with glowing shield, gold/blue gradient, and emergency switch support.
class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final Widget logoContainer = Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.logoGold,
            AppColors.logoBlue,
            primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.logoGold.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 45,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceHighlight,
          border: Border.all(
            color: AppColors.logoGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.shield_outlined,
            size: 58,
            color: AppColors.logoGold,
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Security Command Center Telemetry Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.logoGold.withValues(alpha: 0.12),
            borderRadius: AppRadius.borderRadiusSm,
            border: Border.all(
              color: AppColors.logoGold.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.logoGold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'CYBER OPS CENTER · SECURE INITIALIZE',
                style: TextStyle(
                  color: AppColors.logoGold,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 50.ms)
            .slideY(begin: -0.2, end: 0),

        const SizedBox(height: AppSpacing.md),

        // Floating Shield Icon with Glow (Controlled by enableAdvancedEffects)
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: SplashScreen.enableAdvancedEffects
                  ? GlowEffect(
                      glowColor: AppColors.logoGold,
                      blurRadius: 36,
                      spreadRadius: 6,
                      animate: true,
                      borderRadius: BorderRadius.circular(60),
                      child: logoContainer,
                    )
                  : logoContainer,
            );
          },
        )
            .animate()
            .scale(
              begin: const Offset(0.90, 0.90),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: 500.ms),

        const SizedBox(height: AppSpacing.lg),

        // App Name with Dual-Tone Gradient Typography
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Foren',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
                letterSpacing: 1.2,
                fontFamily: 'Geist',
              ),
            ),
            const Text(
              'Shield',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.logoGold,
                letterSpacing: 1.2,
                fontFamily: 'Geist',
              ),
            ),
          ],
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

        const SizedBox(height: AppSpacing.xs),

        // Tagline
        Text(
          'Learn. Investigate. Defend.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: foren.textSecondary,
            letterSpacing: 0.8,
            fontFamily: 'Geist',
          ),
        )
            .animate(delay: 350.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
      ],
    );
  }
}

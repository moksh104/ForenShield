import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/effects/glass_effect.dart';
import '../../../core/effects/glow_effect.dart';
import '../../../core/effects/particle_background.dart';
import '../../../core/effects/scanner_effect.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/foren_theme.dart';
import '../../../routes/route_constants.dart';
import '../presentation/widgets/auth_button.dart';

/// Dedicated cybersecurity success confirmation screen for Password Reset & Token Verification.
class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final successColor = foren.success.t500;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ParticleBackground(
        numberOfParticles: 30,
        particleColor: successColor,
        duration: const Duration(seconds: 16),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: GlassEffect(
                  blurX: 18.0,
                  blurY: 18.0,
                  opacity: 0.14,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(
                    color: successColor.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Scanner Radar with Glowing Success Icon
                      ScannerEffect(
                        size: 110.0,
                        color: successColor,
                        duration: const Duration(milliseconds: 2500),
                        child: GlowEffect(
                          glowColor: successColor,
                          blurRadius: 20.0,
                          spreadRadius: 4.0,
                          animate: true,
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: successColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadius.large),
                              border: Border.all(
                                color: successColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Icon(
                              Icons.verified_user_outlined,
                              color: successColor,
                              size: 36,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms).scale(),

                      const SizedBox(height: AppSpacing.xl),

                      // Telemetry Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.12),
                          borderRadius: AppRadius.borderRadiusSm,
                          border: Border.all(
                            color: successColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, size: 12, color: successColor),
                            const SizedBox(width: 6),
                            Text(
                              'VERIFICATION COMPLETE · UPLINK SECURED',
                              style: TextStyle(
                                color: successColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace',
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                      const SizedBox(height: AppSpacing.md),

                      // Title
                      Text(
                        'RESET TOKEN DISPATCHED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.08, end: 0),

                      const SizedBox(height: AppSpacing.sm),

                      // Description
                      Text(
                        'If an active agent account exists for the specified email address, password reset instructions have been dispatched.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: foren.textDisabled,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.08, end: 0),

                      const SizedBox(height: AppSpacing.xxl),

                      // Primary Button
                      AuthButton(
                        label: 'RETURN TO AUTHENTICATION',
                        onPressed: () {
                          context.go(RouteConstants.login);
                        },
                      ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.08, end: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

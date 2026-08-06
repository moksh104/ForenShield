import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../config/onboarding_animation_config.dart';
import '../config/onboarding_layout_config.dart';
import '../widgets/academy_illustration.dart';
import '../widgets/background_particles.dart';

/// Screen 2 of the onboarding flow — Cyber Academy.
///
/// Emotional goal: "I will practice, not just read."
///
/// Layout: same 55/45 illustration-to-content split as Screen 1.
/// Category label accent: [AppColors.primary] (Electric Blue) to
/// differentiate from Screen 1's Cyber Cyan.
class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

  static const _bulletItems = [
    (Icons.alternate_email_rounded, 'Phishing Detection', AppColors.error),
    (Icons.qr_code, 'QR Fraud', AppColors.accent),
    (Icons.lock_rounded, 'OTP Scams', AppColors.secondary),
    (Icons.record_voice_over_rounded, 'Social Engineering', AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationHeight =
            OnboardingLayoutConfig.computeIllustrationHeight(
              constraints.maxHeight,
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Illustration zone ─────────────────────────────────────────────
            SizedBox(
              height: illustrationHeight,
              width: double.infinity,
              child: Semantics(
                label: 'Animated training console illustration',
                excludeSemantics: true,
                child: Stack(
                  children: [
                    const SizedBox.expand(child: BackgroundParticles()),
                    AcademyIllustration(animate: !reduceMotion),
                  ],
                ),
              ),
            ),
            // ── Content zone ──────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _categoryLabel(reduceMotion),
                      const SizedBox(height: AppSpacing.sm),
                      _headline(reduceMotion),
                      const SizedBox(height: AppSpacing.lg),
                      _bulletLines(reduceMotion),
                      const SizedBox(height: AppSpacing.xl),
                      _caption(reduceMotion),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Content builders ───────────────────────────────────────────────────────

  Widget _categoryLabel(bool reduceMotion) {
    const label = Text(
      'CYBER ACADEMY',
      style: TextStyle(
        fontFamily: 'Geist',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.5,
        color: AppColors.primary,
      ),
    );
    if (reduceMotion) return label;
    return label
        .animate(delay: OnboardingAnimationConfig.categoryLabelDelay)
        .fadeIn(
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        );
  }

  Widget _headline(bool reduceMotion) {
    const headline = Text(
      'Learn by doing.',
      style: AppTypography.headlineLarge,
    );
    if (reduceMotion) return headline;
    return headline
        .animate(delay: OnboardingAnimationConfig.headlineDelay)
        .fadeIn(
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        );
  }

  Widget _bulletLines(bool reduceMotion) {
    final delays = [
      OnboardingAnimationConfig.line1Delay,
      OnboardingAnimationConfig.line2Delay,
      OnboardingAnimationConfig.line3Delay,
      OnboardingAnimationConfig.line4Delay,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _bulletItems.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: reduceMotion
                ? _BulletLine(item: _bulletItems[i])
                : _BulletLine(item: _bulletItems[i])
                      .animate(delay: delays[i])
                      .fadeIn(
                        duration: OnboardingAnimationConfig.textLineDuration,
                        curve: AppMotion.decelerate,
                      )
                      .slideX(
                        begin: -0.08,
                        end: 0,
                        duration: OnboardingAnimationConfig.textLineDuration,
                        curve: AppMotion.decelerate,
                      ),
          ),
      ],
    );
  }

  Widget _caption(bool reduceMotion) {
    const caption = Text(
      'Interactive lessons  ·  Real-world practice  ·  Instant feedback',
      style: TextStyle(
        fontFamily: 'Geist',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: AppColors.textTertiary,
      ),
    );
    if (reduceMotion) return caption;
    return caption
        .animate(delay: OnboardingAnimationConfig.captionDelay)
        .fadeIn(
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        );
  }
}

// ── Bullet Line ───────────────────────────────────────────────────────────────

class _BulletLine extends StatelessWidget {
  final (IconData, String, Color) item;

  const _BulletLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = item;
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

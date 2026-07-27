import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../config/onboarding_animation_config.dart';
import '../config/onboarding_layout_config.dart';
import '../widgets/background_particles.dart';
import '../widgets/welcome_illustration.dart';

/// Screen 1 of the onboarding flow — Welcome to ForenShield.
///
/// Emotional arc: Curiosity → Confidence → Mission Begins.
///
/// Layout zones:
/// - Upper: Adaptive illustration zone (particles + shield + radar + nodes)
/// - Lower: Content zone (category label, headline, supporting lines, caption)
///
/// Animations are driven by [flutter_animate] (already in project).
/// All durations and curves reference [AppMotion] tokens.
/// Respects [MediaQuery.disableAnimations].
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationHeight =
            OnboardingLayoutConfig.computeIllustrationHeight(constraints.maxHeight);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Illustration zone ─────────────────────────────────────────────
            SizedBox(
              height: illustrationHeight,
              width: double.infinity,
              child: Semantics(
                label: 'Animated security shield illustration',
                excludeSemantics: true,
                child: Stack(
                  children: [
                    const SizedBox.expand(child: BackgroundParticles()),
                    WelcomeIllustration(animate: !reduceMotion),
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
                      _supportingLines(reduceMotion),
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
      'MISSION BRIEFING',
      style: TextStyle(
        fontFamily: 'Geist',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.5,
        color: AppColors.secondary,
      ),
    );
    if (reduceMotion) return label;
    return label
        .animate(delay: OnboardingAnimationConfig.categoryLabelDelay)
        .fadeIn(duration: OnboardingAnimationConfig.textEntryDuration, curve: AppMotion.decelerate)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        );
  }

  Widget _headline(bool reduceMotion) {
    const headline = Text(
      "Cyber threats\ndon't wait.",
      style: AppTypography.headlineLarge,
      semanticsLabel: "Cyber threats don't wait.",
    );
    if (reduceMotion) return headline;
    return headline
        .animate(delay: OnboardingAnimationConfig.headlineDelay)
        .fadeIn(duration: OnboardingAnimationConfig.textEntryDuration, curve: AppMotion.decelerate)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        );
  }

  Widget _supportingLines(bool reduceMotion) {
    const lines = [
      'Train with realistic cyber attacks.',
      'Investigate digital evidence.',
      'Build practical cybersecurity skills.',
    ];
    final delays = [
      OnboardingAnimationConfig.line1Delay,
      OnboardingAnimationConfig.line2Delay,
      OnboardingAnimationConfig.line3Delay,
    ];
    final style = AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: reduceMotion
                ? Text(lines[i], style: style)
                : Text(lines[i], style: style)
                    .animate(delay: delays[i])
                    .fadeIn(duration: OnboardingAnimationConfig.textLineDuration, curve: AppMotion.decelerate),
          ),
      ],
    );
  }

  Widget _caption(bool reduceMotion) {
    const caption = Text(
      'Learn.  Investigate.  Defend.',
      style: TextStyle(
        fontFamily: 'Geist',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
        color: AppColors.textTertiary,
      ),
    );
    if (reduceMotion) return caption;
    return caption
        .animate(delay: OnboardingAnimationConfig.captionDelay)
        .fadeIn(duration: OnboardingAnimationConfig.textEntryDuration, curve: AppMotion.decelerate);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../config/onboarding_animation_config.dart';
import '../config/onboarding_layout_config.dart';
import '../widgets/background_particles.dart';
import '../widgets/investigation_illustration.dart';

/// Screen 3 of the onboarding flow — Investigation Lab.
///
/// Emotional goal: "I solve cybercrime cases."
///
/// Differentiated from previous screens by using [AppColors.accent] (Amber)
/// for the category label, and a slideX animation from the right (positive begin)
/// to suggest filing evidence into a case file.
class InvestigationPage extends StatelessWidget {
  const InvestigationPage({super.key});

  static const _evidenceItems = [
    (Icons.email_rounded, 'Analyze Emails'),
    (Icons.chat_rounded, 'Review Chat Logs'),
    (Icons.language_rounded, 'Inspect Browser History'),
    (Icons.payments_rounded, 'Trace Transactions'),
  ];

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
                label: 'Animated digital evidence board illustration',
                excludeSemantics: true,
                child: Stack(
                  children: [
                    const SizedBox.expand(child: BackgroundParticles()),
                    InvestigationIllustration(animate: !reduceMotion),
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
                      _evidenceLines(reduceMotion),
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
      'INVESTIGATION LAB',
      style: TextStyle(
        fontFamily: 'Geist',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.5,
        color: AppColors.accent, // Amber accent for urgency/case file tone
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
      'Every clue\ntells a story.',
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

  Widget _evidenceLines(bool reduceMotion) {
    final delays = [
      OnboardingAnimationConfig.line1Delay,
      OnboardingAnimationConfig.line2Delay,
      OnboardingAnimationConfig.line3Delay,
      OnboardingAnimationConfig.line4Delay,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _evidenceItems.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: reduceMotion
                ? _EvidenceLine(item: _evidenceItems[i])
                : _EvidenceLine(item: _evidenceItems[i])
                    .animate(delay: delays[i])
                    .fadeIn(
                      duration: OnboardingAnimationConfig.textLineDuration,
                      curve: AppMotion.decelerate,
                    )
                    .slideX(
                      begin: 0.08, // Slide from right (file entering board)
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
      'Connect evidence.  Find the truth.',
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
        .fadeIn(
          duration: OnboardingAnimationConfig.textEntryDuration,
          curve: AppMotion.decelerate,
        );
  }
}

// ── Evidence Line ─────────────────────────────────────────────────────────────

class _EvidenceLine extends StatelessWidget {
  final (IconData, String) item;

  const _EvidenceLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final (icon, label) = item;
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import 'onboarding_dot_indicator.dart';

/// The fixed bottom action area displayed on every onboarding page.
///
/// Renders three zones stacked vertically:
/// 1. [OnboardingDotIndicator] — page position
/// 2. Primary CTA — "Continue" (pages 1-2) or "Get Started" (page 3)
/// 3. Secondary action — "Skip" (pages 1-2) or "I already have an account" (page 3)
///
/// All button variants are existing [AppButton] instances. No new button
/// styles are introduced here.
class OnboardingActionBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;
  final void Function(int index)? onDotTapped;

  const OnboardingActionBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
    required this.onGetStarted,
    required this.onSignIn,
    this.onDotTapped,
  });

  bool get _isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingDotIndicator(
              currentPage: currentPage,
              totalPages: totalPages,
              onDotTapped: onDotTapped,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildPrimaryButton(),
            const SizedBox(height: AppSpacing.sm),
            _buildSecondaryButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    if (_isLastPage) {
      return AppButton(
        text: 'Get Started',
        onPressed: onGetStarted,
        type: AppButtonType.primary,
        trailingIcon: Icons.shield_rounded,
        fullWidth: true,
        semanticLabel: 'Get Started — create your account',
        useHaptics: true,
      );
    }
    return AppButton(
      text: 'Continue',
      onPressed: onNext,
      type: AppButtonType.primary,
      trailingIcon: Icons.arrow_forward_rounded,
      fullWidth: true,
      semanticLabel: 'Continue to step ${currentPage + 2}',
      useHaptics: false,
    );
  }

  Widget _buildSecondaryButton() {
    if (_isLastPage) {
      return AppButton(
        text: 'I already have an account',
        onPressed: onSignIn,
        type: AppButtonType.secondary,
        fullWidth: true,
        semanticLabel: 'Sign in to existing account',
      );
    }
    return AppButton(
      text: 'Skip',
      onPressed: onSkip,
      type: AppButtonType.tertiary,
      fullWidth: true,
      semanticLabel: 'Skip onboarding — go to final screen',
    );
  }
}

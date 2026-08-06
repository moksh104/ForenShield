import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'onboarding_dot_indicator.dart';

/// The bottom action area displayed on onboarding pages matching the design specification.
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary; // #2563EB Cobalt Blue
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary Get Started Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onGetStarted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Page position dots indicator
            OnboardingDotIndicator(
              currentPage: currentPage,
              totalPages: totalPages,
              onDotTapped: onDotTapped,
            ),

            const SizedBox(height: AppSpacing.md),

            // Already have an account? Log in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: onSignIn,
                  child: Text(
                    'Log in',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

/// A reusable success state widget to display completed processes, solved cases, or successful submissions.
class AppSuccessState extends StatelessWidget {
  /// The primary heading explaining the success.
  final String title;

  /// The secondary text providing context on the accomplishment.
  final String description;

  /// The callback executed when the user taps the continue button.
  final VoidCallback onContinue;

  /// The text displayed on the primary action button. Defaults to 'Continue'.
  final String continueText;

  /// The icon representing the success. Defaults to [Icons.check_circle_outline].
  final IconData successIcon;

  /// Whether to play a subtle scale-in animation when the widget first appears.
  final bool animate;

  const AppSuccessState({
    super.key,
    required this.title,
    required this.description,
    required this.onContinue,
    this.continueText = 'Continue',
    this.successIcon = Icons.check_circle_outline,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.1),
                ),
                child: Icon(
                  successIcon,
                  size: 64,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: continueText,
                onPressed: onContinue,
                type: AppButtonType.primary,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );

    if (animate) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: (scale - 0.8) / 0.2, // Maps 0.8->1.0 to 0.0->1.0
              child: child,
            ),
          );
        },
        child: content,
      );
    }

    return content;
  }
}

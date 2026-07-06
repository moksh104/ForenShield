import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

/// A reusable error state widget to display API failures, network issues, or internal errors.
/// 
/// Includes a prominent error icon, context text, and an integrated retry mechanism.
class AppErrorState extends StatelessWidget {
  /// The primary heading explaining the error.
  final String title;

  /// The secondary text providing context on what failed.
  final String description;

  /// The callback executed when the user taps the primary retry button.
  final VoidCallback onRetry;

  /// An optional secondary action button (e.g., "Cancel", "Return to Home").
  final Widget? secondaryAction;

  /// The icon representing the error. Defaults to [Icons.error_outline].
  final IconData errorIcon;

  const AppErrorState({
    super.key,
    this.title = 'An Error Occurred',
    required this.description,
    required this.onRetry,
    this.secondaryAction,
    this.errorIcon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  color: AppColors.error.withValues(alpha: 0.1),
                ),
                child: Icon(
                  errorIcon,
                  size: 64,
                  color: AppColors.error,
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
                text: 'Try Again',
                leadingIcon: Icons.refresh,
                onPressed: onRetry,
                type: AppButtonType.primary,
                fullWidth: true,
              ),
              if (secondaryAction != null) ...[
                const SizedBox(height: AppSpacing.md),
                secondaryAction!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

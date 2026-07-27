import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';
import 'app_button.dart';

/// A reusable error state widget to display API failures, network issues, or internal errors.
class AppErrorState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onRetry;
  final Widget? secondaryAction;
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
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final errorColor = foren.critical.t500;

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
                  color: errorColor.withValues(alpha: 0.1),
                ),
                child: Icon(errorIcon, size: 64, color: errorColor),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foren.textSecondary,
                ),
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

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/foren_theme.dart';

/// Reusable generic ErrorState widget.
/// Used for API failures, data load errors, or unexpected exceptions.
class ErrorState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final String retryLabel;
  final VoidCallback? onRetry;
  final Widget? customAction;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.icon = Icons.error_outline_rounded,
    this.retryLabel = 'Try Again',
    this.onRetry,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>();
    final cs = theme.colorScheme;
    final errorColor = foren?.critical.t500 ?? AppColors.error;

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: errorColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: errorColor),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foren?.textSecondary ?? cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (customAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                customAction!,
              ] else if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(retryLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: errorColor,
                    side: BorderSide(color: errorColor),
                    padding: AppSpacing.buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.buttonRadius,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

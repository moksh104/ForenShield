import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';
import 'app_button.dart';

/// A reusable success state widget to display completed processes, solved cases, or successful submissions.
class AppSuccessState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onContinue;
  final String continueText;
  final IconData successIcon;
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
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final successColor = foren.success.t500;

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
                  color: successColor.withValues(alpha: 0.1),
                ),
                child: Icon(successIcon, size: 64, color: successColor),
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
            child: Opacity(opacity: (scale - 0.8) / 0.2, child: child),
          );
        },
        child: content,
      );
    }

    return content;
  }
}

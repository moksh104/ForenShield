import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';

enum AppLoadingSize { small, medium, large }

class AppLoadingState extends StatelessWidget {
  final String? title;
  final String? description;
  final double? progress;
  final AppLoadingSize size;

  const AppLoadingState({
    super.key,
    this.title,
    this.description,
    this.progress,
    this.size = AppLoadingSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIndicator(theme, foren),
            if (title != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                title!,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foren.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(ThemeData theme, ForenColors foren) {
    if (progress != null) {
      return SizedBox(
        width: 200,
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: foren.surfaceRaised1,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${(progress! * 100).toInt()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    double dimension;
    double strokeWidth;

    switch (size) {
      case AppLoadingSize.small:
        dimension = 24.0;
        strokeWidth = 2.5;
        break;
      case AppLoadingSize.medium:
        dimension = 48.0;
        strokeWidth = 4.0;
        break;
      case AppLoadingSize.large:
        dimension = 72.0;
        strokeWidth = 6.0;
        break;
    }

    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }
}

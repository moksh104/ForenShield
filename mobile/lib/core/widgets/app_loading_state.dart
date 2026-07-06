import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

/// Defines the visual size of the loading indicator in [AppLoadingState].
enum AppLoadingSize { small, medium, large }

/// A highly reusable loading state widget for the ForenShield application.
/// 
/// It can display a simple circular indicator, or optionally include
/// a title, description, and linear progress bar for determinate loading.
class AppLoadingState extends StatelessWidget {
  /// Optional primary title for the loading state.
  final String? title;

  /// Optional secondary description providing more context on what is loading.
  final String? description;

  /// Optional progress value (0.0 to 1.0) for determinate loading.
  /// If null, an indeterminate circular spinner is shown.
  final double? progress;

  /// The size variant of the circular loading indicator. Defaults to [AppLoadingSize.medium].
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIndicator(),
            if (title != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                title!,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    // If determinate progress is provided, show a linear progress bar alongside the size rules
    if (progress != null) {
      return SizedBox(
        width: 200,
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${(progress! * 100).toInt()}%',
              style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      );
    }

    // Otherwise show standard indeterminate circular indicator
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
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}

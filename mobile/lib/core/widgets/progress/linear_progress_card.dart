import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../app_card.dart';
import '../../theme/app_motion.dart';

/// A card that displays a title, description, and an animated linear progress bar.
class LinearProgressCard extends StatelessWidget {
  /// The title of the progress card.
  final String title;

  /// An optional subtitle.
  final String? subtitle;

  /// The current progress value, from 0.0 to 1.0.
  final double progress;

  /// Text to display on the trailing end of the progress bar (e.g., "75%").
  final String? progressText;

  /// The color of the progress bar. Defaults to [AppColors.primary].
  final Color? color;

  const LinearProgressCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.progress,
    this.progressText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    return AppCard(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (progressText != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  progressText!,
                  style: AppTypography.labelLarge.copyWith(color: activeColor),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
            duration: AppMotion.slow,
            curve: AppMotion.standard,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../app_card.dart';
import '../../theme/app_motion.dart';

/// A card that displays progress in a circular format.
class CircularProgressCard extends StatelessWidget {
  /// The title of the progress card.
  final String title;

  /// An optional subtitle.
  final String? subtitle;

  /// The current progress value, from 0.0 to 1.0.
  final double progress;

  /// The widget displayed inside the circular progress indicator (e.g., a Text percentage or Icon).
  final Widget centerWidget;

  /// The color of the progress ring. Defaults to [AppColors.primary].
  final Color? color;

  const CircularProgressCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.progress,
    required this.centerWidget,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    return AppCard(
      body: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              fit: StackFit.expand,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
                  duration: AppMotion.slow,
                  curve: AppMotion.standard,
                  builder: (context, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                      strokeWidth: 6,
                    );
                  },
                ),
                Center(child: centerWidget),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

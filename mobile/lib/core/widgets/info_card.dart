import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

/// Visual style variants for the [InfoCard].
enum InfoCardType { success, warning, error, info }

/// A card designed to display a specific message, status, or alert.
/// 
/// Automatically handles color-coding and layout based on the [InfoCardType].
class InfoCard extends StatelessWidget {
  /// The visual style of the card. Defaults to [InfoCardType.info].
  final InfoCardType type;

  /// The primary icon displayed next to the text.
  final IconData icon;

  /// The main heading text.
  final String title;

  /// Detailed description text.
  final String description;

  /// Optional call-to-action button placed below the description.
  final Widget? ctaButton;

  const InfoCard({
    super.key,
    this.type = InfoCardType.info,
    required this.icon,
    required this.title,
    required this.description,
    this.ctaButton,
  });

  @override
  Widget build(BuildContext context) {
    final colorContext = _getColorContext();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorContext.backgroundColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: colorContext.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorContext.iconColor, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(color: colorContext.titleColor),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(color: colorContext.textColor),
                ),
                if (ctaButton != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  ctaButton!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _InfoCardColors _getColorContext() {
    switch (type) {
      case InfoCardType.success:
        return _InfoCardColors(
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          borderColor: AppColors.success.withValues(alpha: 0.3),
          iconColor: AppColors.success,
          titleColor: AppColors.success,
          textColor: AppColors.textPrimary,
        );
      case InfoCardType.warning:
        return _InfoCardColors(
          backgroundColor: AppColors.warning.withValues(alpha: 0.1),
          borderColor: AppColors.warning.withValues(alpha: 0.3),
          iconColor: AppColors.warning,
          titleColor: AppColors.warning,
          textColor: AppColors.textPrimary,
        );
      case InfoCardType.error:
        return _InfoCardColors(
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          borderColor: AppColors.error.withValues(alpha: 0.3),
          iconColor: AppColors.error,
          titleColor: AppColors.error,
          textColor: AppColors.textPrimary,
        );
      case InfoCardType.info:
        return _InfoCardColors(
          backgroundColor: AppColors.info.withValues(alpha: 0.1),
          borderColor: AppColors.info.withValues(alpha: 0.3),
          iconColor: AppColors.info,
          titleColor: AppColors.info,
          textColor: AppColors.textPrimary,
        );
    }
  }
}

class _InfoCardColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color titleColor;
  final Color textColor;

  _InfoCardColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.titleColor,
    required this.textColor,
  });
}

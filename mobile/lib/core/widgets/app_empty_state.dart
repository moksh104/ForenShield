import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

/// A reusable empty state widget for situations where no data is available.
/// 
/// Ideal for empty catalogues, zero search results, or unpopulated lists.
/// Supports a custom illustration widget or a fallback IconData.
class AppEmptyState extends StatelessWidget {
  /// The primary heading explaining the empty state.
  final String title;

  /// The secondary text providing context or guidance.
  final String description;

  /// A custom illustration widget (e.g., an SVG or Image). Takes precedence over [icon].
  final Widget? illustration;

  /// A fallback icon to display if [illustration] is not provided.
  final IconData? icon;

  /// An optional call-to-action button to help the user resolve the empty state.
  final Widget? actionButton;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.illustration,
    this.icon = Icons.inbox_outlined,
    this.actionButton,
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
              _buildVisual(),
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
              if (actionButton != null) ...[
                const SizedBox(height: AppSpacing.xl),
                actionButton!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisual() {
    if (illustration != null) {
      return illustration!;
    }
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceVariant,
      ),
      child: Icon(
        icon,
        size: 64,
        color: AppColors.textDisabled,
      ),
    );
  }
}

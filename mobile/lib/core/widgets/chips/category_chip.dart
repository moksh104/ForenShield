import 'package:flutter/material.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';

/// A generic categorization chip that accepts custom colors and icons.
/// 
/// Ideal for tagging content with dynamic categories provided by a backend.
class CategoryChip extends StatelessWidget {
  /// The name of the category.
  final String label;

  /// The primary color for the category tag.
  final Color color;

  /// An optional icon to display alongside the category name.
  final IconData? icon;

  const CategoryChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

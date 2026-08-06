import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Clean Category Filter Bar + Filter button matching exact design spec.
class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? onFilterTap;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? AppColors.borderSubtle
        : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // Filter Chips Horizontal Scroll
          Expanded(
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () => onCategorySelected(cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : (isDark ? AppColors.surface : Colors.white),
                        borderRadius: AppRadius.borderRadiusSm,
                        border: Border.all(
                          color: isSelected ? primaryColor : borderColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Right End "Filter" Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : Colors.white,
                borderRadius: AppRadius.borderRadiusSm,
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_outlined, size: 16, color: textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

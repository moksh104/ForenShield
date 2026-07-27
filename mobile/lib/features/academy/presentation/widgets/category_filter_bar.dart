import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Category filter chips & search input for Cyber Academy.
class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback? onProgressTap;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSearchSubmitted,
    this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Action Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onSearchSubmitted,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search courses & topics...',
                    hintStyle: TextStyle(
                      color: foren.textDisabled,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: foren.textDisabled,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: foren.surfaceRaised1,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 10,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              InkWell(
                onTap: onProgressTap,
                borderRadius: AppRadius.borderRadiusMd,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: foren.surfaceRaised1,
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(
                      color: foren.borderSubtle.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.insights_outlined,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Filter Chips Horizontal Scroll List
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat == selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(cat),
                selectedColor: academyColor,
                backgroundColor: foren.surfaceRaised1,
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.scaffoldBackgroundColor
                      : foren.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderRadiusSm,
                  side: BorderSide(
                    color: isSelected
                        ? academyColor
                        : foren.borderSubtle.withValues(alpha: 0.3),
                  ),
                ),
                showCheckmark: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

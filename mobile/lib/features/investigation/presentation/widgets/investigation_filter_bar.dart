import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Filter & Search Bar for Investigation Cases.
class InvestigationFilterBar extends StatelessWidget {
  final List<String> statusFilters;
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;
  final ValueChanged<String> onSearchSubmitted;

  const InvestigationFilterBar({
    super.key,
    required this.statusFilters,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Search Input Field
          GlassEffect(
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
              width: 1.0,
            ),
            borderRadius: AppRadius.borderRadiusMd,
            child: TextField(
              onChanged: onSearchSubmitted,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search cases by title, code, or artifact...',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  color: foren.textSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Status Filter Chips Row
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: statusFilters.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final status = statusFilters[index];
                final isSelected = selectedStatus == status;

                return ChoiceChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (_) => onStatusSelected(status),
                  selectedColor: invColor,
                  backgroundColor: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderRadiusSm,
                    side: BorderSide(
                      color: isSelected ? invColor : foren.borderSubtle,
                      width: 1.0,
                    ),
                  ),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.scaffoldBackgroundColor
                        : foren.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

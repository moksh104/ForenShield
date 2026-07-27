import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Search, Status/Priority filters for Investigation Cases.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: TextField(
            onChanged: onSearchSubmitted,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Search cases by ID or title...',
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
        const SizedBox(height: AppSpacing.sm),
        // Filter Chips Horizontal Scroll List
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: statusFilters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final status = statusFilters[index];
              final isSelected = status == selectedStatus;
              return ChoiceChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (_) => onStatusSelected(status),
                selectedColor: invColor,
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
                        ? invColor
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

import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';
import 'app_navigation_bar.dart';

/// A Material 3 NavigationRail designed for Tablet and Web viewports.
class AppSidebar extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavigationItem> items;
  final bool extended;

  const AppSidebar({
    super.key,
    this.header,
    this.footer,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      backgroundColor: foren.surfaceRaised1,
      indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
      leading: header != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: header,
            )
          : null,
      trailing: footer != null
          ? Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: footer,
            )
          : null,
      useIndicator: true,
      selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.primary,
      ),
      unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: foren.textSecondary,
      ),
      destinations: items.map((item) {
        return NavigationRailDestination(
          icon: Icon(item.icon, color: foren.textSecondary),
          selectedIcon: Icon(
            item.activeIcon ?? item.icon,
            color: theme.colorScheme.primary,
          ),
          label: Text(item.label),
        );
      }).toList(),
    );
  }
}

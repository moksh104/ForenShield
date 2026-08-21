/// ForenShield Component Library — Navigation
/// Top App Bar / Bottom Navigation / Side Navigation (future web/tablet)
///
/// The five destinations are locked per the Design System nav rule and
/// must never change order or grow: Mission Control, Academy,
/// Investigation, Simulation, Profile. Settings lives inside Profile —
/// there is intentionally no 6th destination.
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

export '../navigation/app_breadcrumb.dart';
export '../navigation/app_drawer.dart';
export '../navigation/app_sidebar.dart';
export '../widgets/layouts/app_scaffold.dart';

/// The five locked destinations, in fixed order matching the design spec.
const List<({ForenFeature feature, IconData icon, String label})>
forenNavDestinations = [
  (
    feature: ForenFeature.missionControl,
    icon: Icons.home_outlined,
    label: 'Home',
  ),
  (
    feature: ForenFeature.academy,
    icon: Icons.menu_book_outlined,
    label: 'Learn',
  ),
  (
    feature: ForenFeature.simulation,
    icon: Icons.science_outlined,
    label: 'Lab',
  ),
  (
    feature: ForenFeature.investigation,
    icon: Icons.search_rounded,
    label: 'Investigate',
  ),
  (
    feature: ForenFeature.profile,
    icon: Icons.person_outline_rounded,
    label: 'Profile',
  ),
];

/// Top App Bar. Per Rule 3 (mission / threat / progress always visible),
/// [subtitle] is the standard slot for current-context text — e.g.
/// "Case #0417 — Active" or "3 of 5 objectives complete".
class ForenTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final ForenFeature? feature; // tints the title accent, if provided

  const ForenTopAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.feature,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 68 : 56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = feature != null
        ? (isDark
              ? foren.forFeature(feature!).t300
              : foren.forFeature(feature!).t700)
        : null;

    return AppBar(
      leading: leading,
      actions: actions,
      titleSpacing: leading == null ? ForenSpace.md : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(color: accent),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foren.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Bottom Navigation — mobile primary navigation. Active destination is
/// tinted with *that destination's own* feature accent (Rule: instant
/// feature identity), inactive items use neutral secondary text.
class ForenBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ForenBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: foren.borderSubtle,
            width: ForenBorderWidth.hairline,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        destinations: [
          for (final d in forenNavDestinations)
            NavigationDestination(
              icon: Icon(d.icon, color: foren.textSecondary),
              selectedIcon: Icon(
                d.icon,
                color: isDark
                    ? foren.forFeature(d.feature).t300
                    : foren.forFeature(d.feature).t700,
              ),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

/// Side Navigation — for future web/tablet layout. Same five locked
/// destinations, same per-item accent rule as Bottom Nav, laid out as
/// a persistent rail.
class ForenSideNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool extended;

  const ForenSideNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      extended: extended,
      backgroundColor: theme.scaffoldBackgroundColor,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      destinations: [
        for (final d in forenNavDestinations)
          NavigationRailDestination(
            icon: Icon(d.icon, color: foren.textSecondary),
            selectedIcon: Icon(
              d.icon,
              color: isDark
                  ? foren.forFeature(d.feature).t300
                  : foren.forFeature(d.feature).t700,
            ),
            label: Text(d.label),
          ),
      ],
    );
  }
}

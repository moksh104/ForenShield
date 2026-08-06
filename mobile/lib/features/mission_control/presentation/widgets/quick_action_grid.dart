import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';

/// Item definition for quick action grid.
class QuickActionItem {
  final String label;
  final IconData icon;
  final Color Function(ForenColors foren, ThemeData theme) colorGetter;
  final String routePath;

  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.colorGetter,
    required this.routePath,
  });
}

/// Quick Actions Grid widget supporting primary navigation actions with clean, flat tiles.
class QuickActionGrid extends StatelessWidget {
  final List<QuickActionItem>? customActions;

  const QuickActionGrid({super.key, this.customActions});

  static final List<QuickActionItem> _defaultActions = [
    QuickActionItem(
      label: 'Investigate',
      icon: Icons.biotech_outlined,
      colorGetter: (foren, theme) => foren.investigation.t500,
      routePath: RouteConstants.investigation,
    ),
    QuickActionItem(
      label: 'Academy',
      icon: Icons.school_outlined,
      colorGetter: (foren, theme) => foren.academy.t500,
      routePath: RouteConstants.academy,
    ),
    QuickActionItem(
      label: 'Simulations',
      icon: Icons.terminal_outlined,
      colorGetter: (foren, theme) => foren.simulation.t500,
      routePath: RouteConstants.simulation,
    ),
    QuickActionItem(
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
      colorGetter: (foren, theme) => foren.warning.t500,
      routePath: RouteConstants.reports,
    ),
    QuickActionItem(
      label: 'Achievements',
      icon: Icons.emoji_events_outlined,
      colorGetter: (foren, theme) => foren.warning.t500,
      routePath: RouteConstants.achievementsWall,
    ),
    QuickActionItem(
      label: 'Catalog',
      icon: Icons.grid_view_outlined,
      colorGetter: (foren, theme) => theme.colorScheme.primary,
      routePath: RouteConstants.catalog,
    ),
    QuickActionItem(
      label: 'Profile',
      icon: Icons.person_outline,
      colorGetter: (foren, theme) => foren.info.t500,
      routePath: RouteConstants.profile,
    ),
    QuickActionItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      colorGetter: (foren, theme) => foren.textSecondary,
      routePath: RouteConstants.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final actions = customActions ?? _defaultActions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final item = actions[index];
          return _ActionTile(item: item);
        },
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  final QuickActionItem item;

  const _ActionTile({required this.item});

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final itemColor = widget.item.colorGetter(foren, theme);

    return InkWell(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        context.push(widget.item.routePath);
      },
      borderRadius: AppRadius.borderRadiusMd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCirc,
        decoration: BoxDecoration(
          color: _isPressed
              ? itemColor.withValues(alpha: 0.16)
              : theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: itemColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.item.icon, color: itemColor, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

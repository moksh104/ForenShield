import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
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

/// Quick Actions Grid widget supporting 7 primary navigation actions with glassmorphism & hover effects.
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final itemColor = widget.item.colorGetter(foren, theme);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          context.push(widget.item.routePath);
        },
        borderRadius: AppRadius.borderRadiusMd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          child: GlassEffect(
            blurX: 12.0,
            blurY: 12.0,
            opacity: _isPressed
                ? 0.25
                : (_isHovered ? 0.18 : 0.10),
            borderRadius: AppRadius.borderRadiusMd,
            border: Border.all(
              color: _isPressed || _isHovered
                  ? itemColor.withValues(alpha: 0.7)
                  : foren.borderSubtle.withValues(alpha: 0.35),
              width: _isHovered ? 1.5 : 1.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: itemColor.withValues(alpha: _isHovered ? 0.22 : 0.12),
                    shape: BoxShape.circle,
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: itemColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(widget.item.icon, color: itemColor, size: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.item.label,
                  style: TextStyle(
                    color: _isHovered ? itemColor : theme.colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

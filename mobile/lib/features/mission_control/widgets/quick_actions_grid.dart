import 'package:flutter/material.dart';

/// A responsive quick-actions grid.
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsGrid({super.key, this.actions = const []});

  static List<QuickAction> get defaults => const [
        QuickAction(
          icon: Icons.search_outlined,
          label: 'New Scan',
          color: Color(0xFF34D399),
        ),
        QuickAction(
          icon: Icons.folder_open_outlined,
          label: 'Evidence',
          color: Color(0xFF60A5FA),
        ),
        QuickAction(
          icon: Icons.bar_chart_outlined,
          label: 'Reports',
          color: Color(0xFFFBBF24),
        ),
        QuickAction(
          icon: Icons.fingerprint_outlined,
          label: 'Forensics',
          color: Color(0xFFA78BFA),
        ),
        QuickAction(
          icon: Icons.shield_outlined,
          label: 'Threats',
          color: Color(0xFFF87171),
        ),
        QuickAction(
          icon: Icons.settings_outlined,
          label: 'Settings',
          color: Color(0xFF94A3B8),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayActions = actions.isEmpty ? defaults : actions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayActions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              return _QuickActionTile(action: displayActions[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatefulWidget {
  final QuickAction action;
  const _QuickActionTile({required this.action});

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: widget.action.label,
      button: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.action.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: _pressed
                ? widget.action.color.withValues(alpha: 0.15)
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? widget.action.color.withValues(alpha: 0.4)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.action.icon,
                  color: widget.action.color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.action.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data class representing a quick action tile.
class QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

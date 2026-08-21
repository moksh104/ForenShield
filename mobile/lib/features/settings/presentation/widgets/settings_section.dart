import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'settings_card.dart';

/// Grouped M3 settings section widget with header badge and cards.
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData? headerIcon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    this.headerIcon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.xs + 2,
            top: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (headerIcon != null) ...[
                Icon(headerIcon, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
              ],
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        SettingsCard(children: children),
      ],
    );
  }
}

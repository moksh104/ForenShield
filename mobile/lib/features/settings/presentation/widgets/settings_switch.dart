import 'package:flutter/material.dart';
import '../../../../core/theme/foren_theme.dart';
import 'settings_tile.dart';

/// Specialized M3 switch tile for settings boolean preferences.
class SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const SettingsSwitch({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return SettingsTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      showDivider: showDivider,
      onTap: () => onChanged(!value),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.3),
        inactiveThumbColor: foren.textSecondary,
        inactiveTrackColor: foren.surfaceRaised1,
      ),
    );
  }
}

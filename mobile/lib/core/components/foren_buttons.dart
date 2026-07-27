/// ForenShield Component Library — Buttons
/// Primary / Secondary / Ghost / Danger / Icon Button
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


enum ForenButtonVariant { primary, secondary, ghost, danger }

enum ForenButtonSize { medium, small }

class ForenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ForenButtonVariant variant;

  /// Which feature accent to use for primary/secondary/ghost.
  /// Ignored for [ForenButtonVariant.danger] (always uses Critical).
  /// Defaults to Mission Control if not provided.
  final ForenFeature? feature;
  final IconData? icon;
  final ForenButtonSize size;
  final bool fullWidth;
  final bool loading;

  const ForenButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ForenButtonVariant.primary,
    this.feature,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
  });

  const ForenButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
  }) : variant = ForenButtonVariant.primary;

  const ForenButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
  }) : variant = ForenButtonVariant.secondary;

  const ForenButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
  }) : variant = ForenButtonVariant.ghost;

  const ForenButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
  })  : variant = ForenButtonVariant.danger,
        feature = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    final ForenAccentRamp ramp = variant == ForenButtonVariant.danger
        ? foren.critical
        : foren.forFeature(feature ?? ForenFeature.missionControl);

    final vPad = size == ForenButtonSize.small ? ForenSpace.sm : ForenSpace.md;
    final hPad = size == ForenButtonSize.small ? ForenSpace.md : ForenSpace.lg;
    final textStyle = size == ForenButtonSize.small
        ? theme.textTheme.labelMedium
        : theme.textTheme.labelLarge;

    late final Color bg;
    late final Color fg;
    late final Border? border;

    switch (variant) {
      case ForenButtonVariant.primary:
      case ForenButtonVariant.danger:
        bg = ramp.t500;
        fg = Colors.white;
        border = null;
        break;
      case ForenButtonVariant.secondary:
        bg = Colors.transparent;
        fg = isDark ? ramp.t300 : ramp.t700;
        border = Border.all(color: ramp.t500, width: ForenBorderWidth.defaultWidth);
        break;
      case ForenButtonVariant.ghost:
        bg = Colors.transparent;
        fg = isDark ? ramp.t300 : ramp.t700;
        border = null;
        break;
    }

    final disabled = onPressed == null || loading;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) ...[
          SizedBox(
            width: ForenIconSize.compact,
            height: ForenIconSize.compact,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          ),
          const SizedBox(width: ForenSpace.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: ForenIconSize.compact, color: fg),
          const SizedBox(width: ForenSpace.sm),
        ],
        Flexible(
          child: Text(
            label,
            style: textStyle?.copyWith(color: fg),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Opacity(
      opacity: disabled && variant != ForenButtonVariant.ghost ? 0.5 : 1.0,
      child: Material(
        color: bg,
        borderRadius: ForenRadius.buttonBr,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: ForenRadius.buttonBr,
          child: Container(
            width: fullWidth ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            decoration: BoxDecoration(
              borderRadius: ForenRadius.buttonBr,
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Standalone icon-only button (e.g. app bar actions, card corner actions).
class ForenIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ForenButtonVariant variant;
  final ForenFeature? feature;
  final String? tooltip;
  final double size;

  const ForenIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = ForenButtonVariant.ghost,
    this.feature,
    this.tooltip,
    this.size = ForenIconSize.defaultSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final ramp = variant == ForenButtonVariant.danger
        ? foren.critical
        : foren.forFeature(feature ?? ForenFeature.missionControl);

    late final Color bg;
    late final Color fg;
    switch (variant) {
      case ForenButtonVariant.primary:
      case ForenButtonVariant.danger:
        bg = ramp.t500;
        fg = Colors.white;
        break;
      case ForenButtonVariant.secondary:
      case ForenButtonVariant.ghost:
        bg = variant == ForenButtonVariant.secondary
            ? Colors.transparent
            : Colors.transparent;
        fg = isDark ? ramp.t300 : ramp.t700;
        break;
    }

    final button = Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(ForenSpace.sm),
          child: Icon(icon, size: size, color: fg),
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }
}

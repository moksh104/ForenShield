/// ForenShield Component Library — Primary Button System
/// Unified button implementation supporting Primary, Secondary, Outlined, Destructive, Ghost, Icon buttons, and Loading states.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';
import '../theme/foren_theme.dart';

/// Available button style variants.
enum ForenButtonVariant {
  primary,
  secondary,
  outlined,
  destructive,
  danger,
  ghost,
}

/// Button size options.
enum ForenButtonSize { medium, small }

/// Primary unified button component for ForenShield.
class ForenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ForenButtonVariant variant;
  final ForenFeature? feature;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final IconData? icon;
  final ForenButtonSize size;
  final bool fullWidth;
  final bool loading;
  final String? loadingText;
  final BorderRadius? borderRadius;
  final String? tooltip;
  final String? semanticLabel;
  final bool useHaptics;
  final bool autofocus;
  final FocusNode? focusNode;

  const ForenButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ForenButtonVariant.primary,
    this.feature,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  });

  const ForenButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  }) : variant = ForenButtonVariant.primary;

  const ForenButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  }) : variant = ForenButtonVariant.secondary;

  const ForenButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  }) : variant = ForenButtonVariant.outlined;

  const ForenButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  }) : variant = ForenButtonVariant.destructive,
       feature = null;

  const ForenButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  }) : variant = ForenButtonVariant.danger,
       feature = null;

  const ForenButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.feature,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.size = ForenButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.loadingText,
    this.borderRadius,
    this.tooltip,
    this.semanticLabel,
    this.useHaptics = true,
    this.autofocus = false,
    this.focusNode,
  }) : variant = ForenButtonVariant.ghost;

  bool get _isDisabled => onPressed == null || loading;

  void _handleTap() {
    if (_isDisabled) return;
    if (useHaptics) HapticFeedback.lightImpact();
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final forenThemeExtension = theme.extension<ForenColors>();

    // Determine colors
    Color bg;
    Color fg;
    Border? border;

    if (feature != null && forenThemeExtension != null) {
      final ramp = forenThemeExtension.forFeature(feature!);
      switch (variant) {
        case ForenButtonVariant.primary:
          bg = ramp.t500;
          fg = Colors.white;
          break;
        case ForenButtonVariant.secondary:
          bg = forenThemeExtension.surfaceRaised1;
          fg = isDark ? ramp.t300 : ramp.t700;
          border = Border.all(
            color: forenThemeExtension.borderDefault,
            width: 1.0,
          );
          break;
        case ForenButtonVariant.outlined:
          bg = Colors.transparent;
          fg = isDark ? ramp.t300 : ramp.t700;
          border = Border.all(color: ramp.t500, width: 1.5);
          break;
        case ForenButtonVariant.destructive:
        case ForenButtonVariant.danger:
          bg = AppColors.error;
          fg = Colors.white;
          break;
        case ForenButtonVariant.ghost:
          bg = Colors.transparent;
          fg = isDark ? ramp.t300 : ramp.t700;
          break;
      }
    } else {
      // Theme-aware fallback when no feature accent is specified.
      final cs = theme.colorScheme;
      final foren = forenThemeExtension;
      switch (variant) {
        case ForenButtonVariant.primary:
          bg = cs.primary;
          fg = cs.onPrimary;
          break;
        case ForenButtonVariant.secondary:
          bg = foren?.surfaceRaised1 ?? cs.surfaceContainerHighest;
          fg = cs.onSurface;
          border = Border.all(
            color: foren?.borderDefault ?? cs.outline,
            width: 1.0,
          );
          break;
        case ForenButtonVariant.outlined:
          bg = Colors.transparent;
          fg = cs.primary;
          border = Border.all(color: cs.primary, width: 1.5);
          break;
        case ForenButtonVariant.destructive:
        case ForenButtonVariant.danger:
          bg = cs.error;
          fg = cs.onError;
          border = null;
          break;
        case ForenButtonVariant.ghost:
          bg = Colors.transparent;
          fg = cs.onSurface;
          border = null;
          break;
      }
    }

    if (_isDisabled && variant != ForenButtonVariant.ghost) {
      bg = bg.withValues(alpha: 0.4);
      fg = fg.withValues(alpha: 0.5);
    }

    final vPad = size == ForenButtonSize.small ? AppSpacing.sm : AppSpacing.md;
    final hPad = size == ForenButtonSize.small ? AppSpacing.md : AppSpacing.lg;
    final textStyle = size == ForenButtonSize.small
        ? theme.textTheme.labelMedium
        : theme.textTheme.labelLarge;

    final effectiveLeadingIcon = leadingIcon ?? icon;

    Widget child = AnimatedContainer(
      duration: AppMotion.fast,
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) ...[
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(fg),
              ),
            ),
            if (loadingText != null || label.isNotEmpty)
              const SizedBox(width: AppSpacing.sm),
            if (loadingText != null)
              Flexible(
                child: Text(
                  loadingText!,
                  style: textStyle?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else if (label.isNotEmpty)
              Flexible(
                child: Text(
                  label,
                  style: textStyle?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ] else ...[
            if (effectiveLeadingIcon != null) ...[
              Icon(effectiveLeadingIcon, size: 20, color: fg),
              if (label.isNotEmpty) const SizedBox(width: AppSpacing.sm),
            ],
            if (label.isNotEmpty)
              Flexible(
                child: Text(
                  label,
                  style: textStyle?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (trailingIcon != null) ...[
              if (label.isNotEmpty) const SizedBox(width: AppSpacing.sm),
              Icon(trailingIcon, size: 20, color: fg),
            ],
          ],
        ],
      ),
    );

    Widget button = _SpringButtonWrapper(
      isDisabled: _isDisabled,
      onTap: _handleTap,
      child: Material(
        color: bg,
        shape: AppRadius.buttonShape,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(border: border),
          child: child,
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    if (semanticLabel != null) {
      button = Semantics(
        button: true,
        label: semanticLabel,
        enabled: !_isDisabled,
        child: button,
      );
    }

    return button;
  }
}

class _SpringButtonWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isDisabled;

  const _SpringButtonWrapper({
    required this.child,
    required this.onTap,
    required this.isDisabled,
  });

  @override
  State<_SpringButtonWrapper> createState() => _SpringButtonWrapperState();
}

class _SpringButtonWrapperState extends State<_SpringButtonWrapper> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isDisabled
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onTap();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed && !widget.isDisabled ? 0.95 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.micro,
        child: widget.child,
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
  final bool useHaptics;

  const ForenIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = ForenButtonVariant.ghost,
    this.feature,
    this.tooltip,
    this.size = 24.0,
    this.useHaptics = true,
  });

  void _handleTap() {
    if (onPressed == null) return;
    if (useHaptics) HapticFeedback.lightImpact();
    onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foren = theme.extension<ForenColors>();

    Color bg;
    Color fg;

    if (feature != null && foren != null) {
      final ramp = foren.forFeature(feature!);
      fg = isDark ? ramp.t300 : ramp.t700;
      bg = variant == ForenButtonVariant.primary
          ? ramp.t500
          : Colors.transparent;
    } else {
      // Theme-aware fallback when no feature accent is specified.
      final cs = theme.colorScheme;
      switch (variant) {
        case ForenButtonVariant.primary:
          bg = cs.primary;
          fg = cs.onPrimary;
          break;
        case ForenButtonVariant.destructive:
        case ForenButtonVariant.danger:
          bg = cs.error;
          fg = cs.onError;
          break;
        case ForenButtonVariant.secondary:
        case ForenButtonVariant.outlined:
        case ForenButtonVariant.ghost:
          bg = Colors.transparent;
          fg = cs.onSurface;
          break;
      }
    }

    final button = Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed == null ? null : _handleTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, size: size, color: fg),
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }
}

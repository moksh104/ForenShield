import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_motion.dart';
import '../theme/foren_theme.dart';

/// Defines the visual styling variant of the [AppButton].
enum AppButtonType { primary, secondary, tertiary, destructive }

/// A highly customizable, reusable button component following the ForenShield UX Blueprint.
/// Colors are sourced from the live ForenTheme/ForenColors rather than hard-coded values.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final double? width;
  final double? height;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String? semanticLabel;
  final String? tooltip;
  final BorderRadius? borderRadius;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? loadingText;
  final bool useHaptics;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.width,
    this.height,
    this.leadingIcon,
    this.trailingIcon,
    this.semanticLabel,
    this.tooltip,
    this.borderRadius,
    this.autofocus = false,
    this.focusNode,
    this.loadingText,
    this.useHaptics = true,
  });

  bool get _isDisabled => onPressed == null || isLoading;

  void _handlePress() {
    if (_isDisabled) return;
    if (useHaptics) HapticFeedback.lightImpact();
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = _buildButtonVariant(context);

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

    // Wrap in ClipRRect to ensure ripple doesn't bleed outside the custom border radius
    button = ClipRRect(
      borderRadius: borderRadius ?? AppRadius.borderMd,
      child: button,
    );

    if (fullWidth || width != null || height != null) {
      return SizedBox(
        width: fullWidth ? double.infinity : width,
        height: height,
        child: button,
      );
    }
    return button;
  }

  Widget _buildButtonVariant(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final style = _getBaseStyle(context);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? foren.surfaceRaised1
                  : theme.colorScheme.primary,
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? foren.textDisabled
                  : theme.scaffoldBackgroundColor,
            ),
            elevation: WidgetStateProperty.all(1),
          ),
          child: _buildChild(context),
        );
      case AppButtonType.secondary:
        return OutlinedButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            side: WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? foren.borderSubtle
                    : theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
          child: _buildChild(context),
        );
      case AppButtonType.tertiary:
        return TextButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(elevation: WidgetStateProperty.all(0)),
          child: _buildChild(context),
        );
      case AppButtonType.destructive:
        return ElevatedButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? foren.surfaceRaised1
                  : theme.colorScheme.error,
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? foren.textDisabled
                  : theme.colorScheme.onError,
            ),
            elevation: WidgetStateProperty.all(1),
          ),
          child: _buildChild(context),
        );
    }
  }

  ButtonStyle _getBaseStyle(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    return ButtonStyle(
      animationDuration: AppMotion.fast,
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 48)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppRadius.borderMd,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? foren.textDisabled
            : theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final textColor = _isDisabled ? foren.textDisabled : _getTextColor(context);
    final textStyle = theme.textTheme.labelLarge?.copyWith(color: textColor);

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          if (loadingText != null || text.isNotEmpty)
            const SizedBox(width: AppSpacing.sm),
          if (loadingText != null)
            Text(loadingText!, style: textStyle)
          else
            Text(text, style: textStyle),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20, color: textColor),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text, style: textStyle),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: 20, color: textColor),
        ],
      ],
    );
  }

  Color _getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    switch (type) {
      case AppButtonType.primary:
        return theme.scaffoldBackgroundColor;
      case AppButtonType.secondary:
      case AppButtonType.tertiary:
        return theme.colorScheme.primary;
      case AppButtonType.destructive:
        return foren.critical.t500;
    }
  }
}

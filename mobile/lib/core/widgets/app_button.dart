import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_motion.dart';

/// Defines the visual styling variant of the [AppButton].
enum AppButtonType { primary, secondary, tertiary, destructive }

/// A highly customizable, reusable button component following the ForenShield UX Blueprint.
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
    Widget button = _buildButtonVariant();

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

  Widget _buildButtonVariant() {
    final style = _getBaseStyle();

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.disabled) ? AppColors.surfaceVariant : AppColors.primary),
            foregroundColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.disabled) ? AppColors.textDisabled : AppColors.background),
            elevation: WidgetStateProperty.all(1),
          ),
          child: _buildChild(),
        );
      case AppButtonType.secondary:
        return OutlinedButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            side: WidgetStateProperty.resolveWith((states) => BorderSide(
                  color: states.contains(WidgetState.disabled) ? AppColors.outline : AppColors.primary,
                  width: 1.5,
                )),
          ),
          child: _buildChild(),
        );
      case AppButtonType.tertiary:
        return TextButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            elevation: WidgetStateProperty.all(0),
          ),
          child: _buildChild(),
        );
      case AppButtonType.destructive:
        return ElevatedButton(
          onPressed: _isDisabled ? null : _handlePress,
          autofocus: autofocus,
          focusNode: focusNode,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.disabled) ? AppColors.surfaceVariant : AppColors.error),
            foregroundColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.disabled) ? AppColors.textDisabled : AppColors.textPrimary),
            elevation: WidgetStateProperty.all(1),
          ),
          child: _buildChild(),
        );
    }
  }

  ButtonStyle _getBaseStyle() {
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
      foregroundColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.disabled) ? AppColors.textDisabled : AppColors.primary),
    );
  }

  Widget _buildChild() {
    final textColor = _isDisabled ? AppColors.textDisabled : _getTextColor();
    final textStyle = AppTypography.labelLarge.copyWith(color: textColor);

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
          if (loadingText != null || text.isNotEmpty) const SizedBox(width: AppSpacing.sm),
          if (loadingText != null) Text(loadingText!, style: textStyle) else Text(text, style: textStyle),
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

  Color _getTextColor() {
    switch (type) {
      case AppButtonType.primary:
        return AppColors.background;
      case AppButtonType.secondary:
      case AppButtonType.tertiary:
        return AppColors.primary;
      case AppButtonType.destructive:
        return AppColors.textPrimary;
    }
  }
}

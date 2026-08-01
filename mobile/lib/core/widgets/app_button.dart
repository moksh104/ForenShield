import 'package:flutter/material.dart';
import '../components/foren_buttons.dart';

/// Defines the visual styling variant of the [AppButton].
enum AppButtonType { primary, secondary, tertiary, destructive }

/// A highly customizable, backward-compatible button wrapper delegating directly to [ForenButton].
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

  ForenButtonVariant get _variant {
    switch (type) {
      case AppButtonType.primary:
        return ForenButtonVariant.primary;
      case AppButtonType.secondary:
        return ForenButtonVariant.outlined;
      case AppButtonType.tertiary:
        return ForenButtonVariant.ghost;
      case AppButtonType.destructive:
        return ForenButtonVariant.destructive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ForenButton(
      label: text,
      onPressed: onPressed,
      variant: _variant,
      loading: isLoading,
      loadingText: loadingText,
      fullWidth: fullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      borderRadius: borderRadius,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      useHaptics: useHaptics,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/foren_theme.dart';

/// A highly configurable, base text input component for ForenShield.
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool showCounter;
  final bool isSuccess;
  final bool isLoading;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.showCounter = false,
    this.isSuccess = false,
    this.isLoading = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _internalController;
  late FocusNode _internalFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }

    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) _internalController.dispose();
      if (widget.controller == null) {
        _internalController = TextEditingController(
          text: oldWidget.controller?.text,
        );
        _internalController.addListener(_onTextChanged);
      } else {
        widget.controller!.addListener(_onTextChanged);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.removeListener(_onTextChanged);
      _internalController.dispose();
    } else {
      widget.controller!.removeListener(_onTextChanged);
    }

    if (widget.focusNode == null) {
      _internalFocusNode.removeListener(_onFocusChanged);
      _internalFocusNode.dispose();
    } else {
      widget.focusNode!.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final effectiveSuffix = _buildSuffix(foren);
    final effectiveBorderRadius = AppRadius.borderMd;

    final primaryColor = theme.colorScheme.primary;
    final errorColor = foren.critical.t500;
    final successColor = foren.success.t500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: widget.enabled
                  ? theme.colorScheme.onSurface
                  : foren.textDisabled,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.enabled
                ? theme.colorScheme.onSurface
                : foren.textDisabled,
          ),
          cursorColor: primaryColor,
          buildCounter: _buildCounter,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: foren.textDisabled,
            ),
            helperText: widget.helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: effectiveSuffix,
            filled: true,
            fillColor: widget.enabled
                ? foren.surfaceRaised1
                : theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(color: foren.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: widget.isSuccess ? successColor : foren.borderSubtle,
                width: widget.isSuccess ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: widget.isSuccess ? successColor : primaryColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(color: errorColor, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(color: errorColor, width: 2.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: foren.borderSubtle.withValues(alpha: 0.5),
              ),
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: errorColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix(ForenColors foren) {
    final List<Widget> suffixes = [];

    if (widget.isLoading) {
      suffixes.add(
        const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    } else if (widget.isSuccess) {
      suffixes.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Icon(Icons.check_circle, color: foren.success.t500),
        ),
      );
    }

    if (widget.showClearButton &&
        _hasText &&
        widget.enabled &&
        !widget.readOnly) {
      suffixes.add(
        IconButton(
          icon: const Icon(Icons.clear, size: 20),
          color: foren.textSecondary,
          onPressed: _clearText,
          splashRadius: 20,
        ),
      );
    }

    if (widget.suffixIcon != null) {
      suffixes.add(widget.suffixIcon!);
    }

    if (suffixes.isEmpty) return null;

    if (suffixes.length == 1) return suffixes.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: suffixes,
    );
  }

  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    if (!widget.showCounter || maxLength == null) return null;
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    return Text(
      '$currentLength / $maxLength',
      style: theme.textTheme.labelSmall?.copyWith(
        color: isFocused ? theme.colorScheme.onSurface : foren.textSecondary,
      ),
    );
  }
}

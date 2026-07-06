import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

/// A highly configurable, base text input component for ForenShield.
/// 
/// It acts as the foundational root for all other specific field types.
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

  TextEditingController get _controller => widget.controller ?? _internalController;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _internalController = TextEditingController();
    if (widget.focusNode == null) _internalFocusNode = FocusNode();

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
        _internalController = TextEditingController(text: oldWidget.controller?.text);
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
    setState(() {}); // Rebuild for focused states if needed
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSuffix = _buildSuffix();
    final effectiveBorderRadius = AppRadius.borderMd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelLarge.copyWith(
              color: widget.enabled ? AppColors.textPrimary : AppColors.textDisabled,
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
          style: AppTypography.bodyLarge.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textDisabled,
          ),
          cursorColor: AppColors.primary,
          buildCounter: _buildCounter,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textDisabled),
            helperText: widget.helperText,
            helperStyle: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            prefixIcon: widget.prefixIcon,
            suffixIcon: effectiveSuffix,
            filled: true,
            fillColor: widget.enabled ? AppColors.surfaceVariant : AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: widget.isSuccess ? AppColors.success : AppColors.outline,
                width: widget.isSuccess ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: widget.isSuccess ? AppColors.success : AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(color: AppColors.error, width: 2.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.5)),
            ),
            errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Icon(Icons.check_circle, color: AppColors.success),
        ),
      );
    }

    if (widget.showClearButton && _hasText && widget.enabled && !widget.readOnly) {
      suffixes.add(
        IconButton(
          icon: const Icon(Icons.clear, size: 20),
          color: AppColors.textSecondary,
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
    return Text(
      '$currentLength / $maxLength',
      style: AppTypography.labelSmall.copyWith(
        color: isFocused ? AppColors.textPrimary : AppColors.textSecondary,
      ),
    );
  }
}

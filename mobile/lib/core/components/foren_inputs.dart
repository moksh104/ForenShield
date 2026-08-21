/// ForenShield Component Library — Primary Inputs System
/// Unified TextField component supporting Validation, Password fields, Icons (Widget & IconData), Loading states, and Search mode.
library;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/foren_theme.dart';

/// Primary unified text field component for ForenShield.
class ForenTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final dynamic prefixIcon;
  final dynamic suffixIcon;
  final bool showClearButton;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final bool isPassword;
  final bool isSearch;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
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

  const ForenTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.isPassword = false,
    this.isSearch = false,
    this.validator,
    this.autovalidateMode,
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

  const ForenTextField.password({
    super.key,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.helperText,
    this.errorText,
    this.prefixIcon = Icons.lock_outline,
    this.suffixIcon,
    this.showClearButton = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.maxLength,
    this.showCounter = false,
    this.isSuccess = false,
    this.isLoading = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  }) : obscureText = true,
       isPassword = true,
       isSearch = false,
       keyboardType = TextInputType.visiblePassword,
       maxLines = 1,
       minLines = 1;

  const ForenTextField.search({
    super.key,
    this.label,
    this.hint = 'Search...',
    this.helperText,
    this.errorText,
    this.prefixIcon = Icons.search,
    this.suffixIcon,
    this.showClearButton = true,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.search,
    this.maxLength,
    this.showCounter = false,
    this.isSuccess = false,
    this.isLoading = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  }) : obscureText = false,
       isPassword = false,
       isSearch = true,
       maxLines = 1,
       minLines = 1;

  @override
  State<ForenTextField> createState() => _ForenTextFieldState();
}

class _ForenTextFieldState extends State<ForenTextField> {
  late TextEditingController _internalController;
  late FocusNode _internalFocusNode;
  late bool _obscureText;
  bool _hasText = false;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword || widget.obscureText;
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
  void didUpdateWidget(ForenTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText ||
        oldWidget.isPassword != widget.isPassword) {
      _obscureText = widget.isPassword || widget.obscureText;
    }
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget? _resolveIcon(dynamic iconInput, Color color) {
    if (iconInput == null) return null;
    if (iconInput is IconData) {
      return Icon(iconInput, size: 20, color: color);
    }
    if (iconInput is Widget) {
      return iconInput;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>();
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = theme.colorScheme.primary;
    final errorColor = foren?.critical.t500 ?? AppColors.error;
    final successColor = foren?.success.t500 ?? AppColors.success;
    final textSecondary = foren?.textSecondary ?? AppColors.textSecondary;
    final textDisabled = foren?.textDisabled ?? AppColors.textDisabled;
    final surfaceFill = widget.enabled
        ? (foren?.surfaceRaised1 ?? AppColors.surfaceHighlight)
        : (isDark ? AppColors.bgBase : AppColors.lightSurface);

    final effectiveRadius = widget.isSearch
        ? BorderRadius.circular(AppRadius.pill)
        : AppRadius.buttonRadius;

    final effectivePrefix = _resolveIcon(widget.prefixIcon, textSecondary);
    final effectiveSuffix = _buildSuffix(foren, textSecondary, successColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelLarge.copyWith(
              color: widget.enabled
                  ? (isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary)
                  : textDisabled,
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
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          style: AppTypography.bodyLarge.copyWith(
            color: widget.enabled
                ? (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)
                : textDisabled,
          ),
          cursorColor: primaryColor,
          buildCounter: _buildCounter,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyMedium.copyWith(color: textDisabled),
            helperText: widget.helperText,
            helperStyle: AppTypography.bodySmall.copyWith(color: textSecondary),
            errorText: widget.errorText,
            prefixIcon: effectivePrefix,
            suffixIcon: effectiveSuffix,
            filled: true,
            fillColor: surfaceFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: foren?.borderSubtle ?? theme.colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: widget.isSuccess
                    ? successColor
                    : (foren?.borderSubtle ?? theme.colorScheme.outlineVariant),
                width: widget.isSuccess ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: widget.isSuccess ? successColor : primaryColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(color: errorColor, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(color: errorColor, width: 2.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: effectiveRadius,
              borderSide: BorderSide(
                color: (foren?.borderSubtle ?? theme.colorScheme.outlineVariant)
                    .withValues(alpha: 0.5),
              ),
            ),
            errorStyle: AppTypography.bodySmall.copyWith(color: errorColor),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix(
    ForenColors? foren,
    Color textSecondary,
    Color successColor,
  ) {
    final List<Widget> suffixes = [];

    if (widget.isLoading) {
      suffixes.add(
        const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    } else if (widget.isSuccess) {
      suffixes.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Icon(Icons.check_circle, color: successColor, size: 20),
        ),
      );
    }

    if (widget.showClearButton &&
        _hasText &&
        widget.enabled &&
        !widget.readOnly) {
      suffixes.add(
        IconButton(
          icon: const Icon(Icons.clear, size: 18),
          color: textSecondary,
          onPressed: _clearText,
          splashRadius: 18,
        ),
      );
    }

    if (widget.isPassword || widget.obscureText) {
      suffixes.add(
        IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
          ),
          color: textSecondary,
          onPressed: _togglePasswordVisibility,
          splashRadius: 20,
        ),
      );
    }

    final customSuffix = _resolveIcon(widget.suffixIcon, textSecondary);
    if (customSuffix != null) {
      suffixes.add(customSuffix);
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
    final foren = theme.extension<ForenColors>();
    final secondaryColor =
        foren?.textSecondary ?? theme.colorScheme.onSurfaceVariant;
    final primaryColor = foren?.textSecondary ?? theme.colorScheme.onSurface;
    return Text(
      '$currentLength / $maxLength',
      style: AppTypography.labelSmall.copyWith(
        color: isFocused ? primaryColor : secondaryColor,
      ),
    );
  }
}

/// Search input bar alias.
class ForenSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const ForenSearchBar({
    super.key,
    this.hint = 'Search',
    this.onChanged,
    this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ForenTextField.search(
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      suffixIcon: onFilterTap != null
          ? IconButton(
              icon: const Icon(Icons.tune, size: 20),
              onPressed: onFilterTap,
            )
          : null,
    );
  }
}

/// Toggleable filter chip pill.
class ForenFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final ForenFeature? feature;

  const ForenFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.feature,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>();
    final ramp = foren?.forFeature(feature ?? ForenFeature.missionControl);
    final fg = selected
        ? Colors.white
        : (foren?.textSecondary ?? theme.colorScheme.onSurfaceVariant);
    final bg = selected
        ? (ramp?.t500 ?? AppColors.primary)
        : (foren?.surfaceRaised1 ?? AppColors.surfaceHighlight);

    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: ForenMotionDuration.micro,
        curve: ForenMotionCurve.micro,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(color: fg),
        ),
      ),
    );
  }
}

/// Standard dropdown field styled identically to ForenTextField.
class ForenDropdown<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const ForenDropdown({
    super.key,
    this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>();
    final fillColor =
        foren?.surfaceRaised1 ?? theme.colorScheme.surfaceContainerHighest;
    final borderColor = foren?.borderSubtle ?? theme.colorScheme.outlineVariant;

    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(itemLabel(item))),
      ],
      onChanged: onChanged,
    );
  }
}

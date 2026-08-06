import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Reusable text field for authentication forms with clear focus states.
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late FocusNode _effectiveFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    } else {
      _effectiveFocusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _effectiveFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF475569);
    final placeholderColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF94A3B8);
    final borderColor = isDark
        ? AppColors.borderSubtle
        : const Color(0xFFE2E8F0);
    final surfaceColor = isDark ? AppColors.surface : Colors.white;
    final errorColor = foren.critical.t500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: _isFocused ? primaryColor : textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderRadiusMd,
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? primaryColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: isDark ? 0.0 : 0.02),
                blurRadius: _isFocused ? 12.0 : 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GlassEffect(
            color: surfaceColor,
            borderRadius: AppRadius.borderRadiusMd,
            border: Border.all(
              color: _isFocused ? primaryColor : borderColor,
              width: _isFocused ? 1.5 : 1.0,
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              validator: widget.validator,
              onFieldSubmitted: widget.onFieldSubmitted,
              focusNode: _effectiveFocusNode,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              style: theme.textTheme.bodyLarge?.copyWith(color: textPrimary),
              cursorColor: primaryColor,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: placeholderColor,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? IconTheme(
                        data: IconThemeData(
                          color: _isFocused ? primaryColor : textSecondary,
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconTheme(
                        data: IconThemeData(
                          color: _isFocused ? primaryColor : textSecondary,
                          size: 20,
                        ),
                        child: widget.suffixIcon!,
                      )
                    : null,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: theme.textTheme.bodySmall?.copyWith(
                  color: errorColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

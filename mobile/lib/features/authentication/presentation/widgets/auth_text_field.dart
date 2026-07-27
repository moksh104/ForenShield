import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Reusable text field for authentication forms.
class AuthTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final errorColor = foren.critical.t500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: foren.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          enabled: enabled,
          maxLines: maxLines,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: foren.textDisabled.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: foren.surfaceRaised1,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            border: const OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusMd,
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusMd,
              borderSide: BorderSide(
                color: foren.borderSubtle.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusMd,
              borderSide: BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusMd,
              borderSide: BorderSide(
                color: errorColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderRadiusMd,
              borderSide: BorderSide(
                color: errorColor,
                width: 1.5,
              ),
            ),
            errorStyle: TextStyle(
              color: errorColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

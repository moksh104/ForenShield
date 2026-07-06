import 'package:flutter/material.dart';
import 'app_text_field.dart';

/// A specialized text field optimized for long-form content.
/// 
/// Automatically grows within the [minLines] and [maxLines] constraints
/// and natively supports character counters.
class MultilineField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int minLines;
  final int maxLines;
  final int? maxLength;

  const MultilineField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 10,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      helperText: helperText,
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      showCounter: maxLength != null,
      showClearButton: false, // Usually undesirable in large text areas
    );
  }
}

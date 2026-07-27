import 'package:flutter/material.dart';
import '../theme/foren_theme.dart';
import 'app_text_field.dart';

/// A specialized text field optimized for search operations.
class SearchField extends StatelessWidget {
  final String? hint;
  final bool enabled;
  final bool isLoading;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool autofocus;

  const SearchField({
    super.key,
    this.hint = 'Search...',
    this.enabled = true,
    this.isLoading = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return AppTextField(
      hint: hint,
      enabled: enabled,
      isLoading: isLoading,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      prefixIcon: Icon(Icons.search, color: foren.textSecondary),
      showClearButton: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      maxLines: 1,
    );
  }
}

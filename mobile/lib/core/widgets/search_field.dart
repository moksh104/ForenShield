import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_text_field.dart';

/// A specialized text field optimized for search operations.
/// 
/// Automatically includes a search icon prefix and an instant clear suffix button.
/// Provides a clean API ready for debounced search operations.
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
    return AppTextField(
      hint: hint,
      enabled: enabled,
      isLoading: isLoading,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
      showClearButton: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      maxLines: 1,
    );
  }
}

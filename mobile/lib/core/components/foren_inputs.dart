/// ForenShield Component Library — Inputs
/// Search Bar / Filter Chip / Dropdown / TextField
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Standard text field. Wraps the global inputDecorationTheme so
/// label/border/focus states stay consistent everywhere.
class ForenTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  const ForenTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.errorText,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: ForenIconSize.defaultSize) : null,
      ),
    );
  }
}

/// Search input — pill-shaped per badge/chip radius convention,
/// distinct from the standard rectangular TextField.
class ForenSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const ForenSearchBar({
    super.key,
    this.hint = 'Search',
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      decoration: BoxDecoration(color: foren.surfaceRaised1, borderRadius: ForenRadius.pillBr),
      padding: const EdgeInsets.symmetric(horizontal: ForenSpace.md),
      child: Row(
        children: [
          Icon(Icons.search, size: ForenIconSize.defaultSize, color: foren.textSecondary),
          const SizedBox(width: ForenSpace.sm),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: ForenSpace.sm),
              ),
            ),
          ),
          if (onFilterTap != null)
            IconButton(
              icon: Icon(Icons.tune, size: ForenIconSize.compact, color: foren.textSecondary),
              onPressed: onFilterTap,
            ),
        ],
      ),
    );
  }
}

/// Toggleable filter pill (e.g. "Critical only", "This week").
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
    final foren = theme.extension<ForenColors>()!;
    final ramp = foren.forFeature(feature ?? ForenFeature.missionControl);
    final fg = selected ? Colors.white : foren.textSecondary;
    final bg = selected ? ramp.t500 : foren.surfaceRaised1;

    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: ForenMotionDuration.micro,
        curve: ForenMotionCurve.micro,
        padding: const EdgeInsets.symmetric(horizontal: ForenSpace.md, vertical: ForenSpace.sm),
        decoration: BoxDecoration(color: bg, borderRadius: ForenRadius.pillBr),
        child: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: fg)),
      ),
    );
  }
}

/// Standard dropdown, styled to match ForenTextField.
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
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),

      items: [
        for (final item in items) DropdownMenuItem(value: item, child: Text(itemLabel(item))),
      ],
      onChanged: onChanged,
    );
  }
}

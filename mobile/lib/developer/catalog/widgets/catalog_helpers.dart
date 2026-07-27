/// ForenShield Widget Catalog — shared layout helpers.
/// Purely presentational scaffolding for the catalog itself; these
/// are NOT part of the component library and consume the theme only
/// (no new tokens introduced).
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/foren_theme.dart';

/// Top-level section: "Buttons", "Cards", etc.
class CatalogSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const CatalogSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: ForenSpace.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineLarge),
          const SizedBox(height: ForenSpace.xs),
          Text(description, style: theme.textTheme.bodyMedium?.copyWith(color: foren.textSecondary)),
          const SizedBox(height: ForenSpace.lg),
          child,
        ],
      ),
    );
  }
}

/// Sub-grouping inside a section, e.g. "Primary" within "Buttons".
class CatalogSubsection extends StatelessWidget {
  final String label;
  final Widget child;

  const CatalogSubsection({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: ForenSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(color: foren.textSecondary, letterSpacing: 0.06),
          ),
          const SizedBox(height: ForenSpace.sm),
          child,
        ],
      ),
    );
  }
}

/// Lays out a handful of component instances with even spacing —
/// used for "here's every variant side by side" rows.
class CatalogPropRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const CatalogPropRow({super.key, required this.children, this.spacing = ForenSpace.sm});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: spacing, children: children);
  }
}

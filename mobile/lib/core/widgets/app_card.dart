import 'package:flutter/material.dart';
import '../components/foren_cards.dart';

/// A standard, backward-compatible card component wrapper delegating directly to [ForenCard].
class AppCard extends StatelessWidget {
  /// The main content of the card.
  final Widget body;

  /// Optional custom header. If provided, overrides [title] and [subtitle].
  final Widget? header;

  /// Optional custom footer, displayed below the body.
  final Widget? footer;

  /// Optional icon displayed at the start of the standard header.
  final IconData? leadingIcon;

  /// Optional action widget (like an IconButton) displayed at the end of the standard header.
  final Widget? trailingAction;

  /// Standard title for the card. Used if [header] is null.
  final String? title;

  /// Standard subtitle for the card. Used if [header] is null.
  final String? subtitle;

  /// The elevation level of the card. Defaults to 1.
  final double elevation;

  /// Whether the card has a subtle outline border. Defaults to true.
  final bool hasBorder;

  /// Internal padding for the card content.
  final EdgeInsetsGeometry padding;

  /// Optional tap handler for the entire card.
  final VoidCallback? onTap;

  /// Border radius override.
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.body,
    this.header,
    this.footer,
    this.leadingIcon,
    this.trailingAction,
    this.title,
    this.subtitle,
    this.elevation = 1,
    this.hasBorder = true,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final mode = elevation > 0
        ? ForenCardMode.elevated
        : (hasBorder ? ForenCardMode.bordered : ForenCardMode.bordered);

    return ForenCard(
      body: body,
      header: header,
      footer: footer,
      leadingIcon: leadingIcon,
      trailingAction: trailingAction,
      title: title,
      subtitle: subtitle,
      elevation: elevation,
      hasBorder: hasBorder,
      padding: padding,
      onTap: onTap,
      borderRadius: borderRadius,
      mode: mode,
    );
  }
}

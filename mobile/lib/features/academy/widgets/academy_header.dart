import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// A production-grade, stateless header for the Cyber Academy.
///
/// - Uses Material 3 theming via Theme.of(context).colorScheme
/// - Accepts a simple [title], [subtitle], optional [avatar] widget and [levelText]
/// - Presentation-only: no business logic, only visual composition
/// - All constructors are const so widget can be reused in const contexts
class AcademyHeader extends StatelessWidget {
  /// Display title of the academy section
  final String title;

  /// Short subtitle or description
  final String subtitle;

  /// Optional avatar or icon shown on the left
  final Widget? avatar;

  /// Small level label shown on the right
  final String levelText;

  /// Optional progress 0.0-1.0 displayed in the level pill
  final double levelProgress;

  const AcademyHeader({
    Key? key,
    this.title = 'ForenShield Academy',
    this.subtitle = 'Advance your cybersecurity skills',
    this.avatar,
    this.levelText = 'Lvl 1',
    this.levelProgress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.primary, color.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              avatar ?? _defaultAvatar(color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color.onPrimary, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color.onPrimary.withOpacity(0.9))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _levelPill(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar(ColorScheme color) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [color.primaryContainer, color.secondaryContainer]),
      ),
      child: Icon(Icons.shield, color: color.onPrimary, size: 34),
    );
  }

  Widget _levelPill(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: cs.onPrimary.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(levelText, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onPrimary)),
          const SizedBox(height: 6),
          SizedBox(width: 64, child: LinearProgressIndicator(value: levelProgress, color: cs.onPrimary, backgroundColor: cs.onPrimary.withOpacity(0.18))),
        ],
      ),
    );
  }
}

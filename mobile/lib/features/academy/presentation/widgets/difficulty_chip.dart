import 'package:flutter/material.dart';

/// Simple difficulty display chip.
///
/// - Accepts difficulty label (e.g., Beginner, Intermediate, Advanced)
class DifficultyChip extends StatelessWidget {
  final String difficulty;

  const DifficultyChip({Key? key, required this.difficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color bg;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        bg = cs.primary.withOpacity(0.12);
        break;
      case 'intermediate':
        bg = cs.secondary.withOpacity(0.12);
        break;
      case 'advanced':
        bg = cs.error.withOpacity(0.12);
        break;
      default:
        bg = cs.surfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(difficulty, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

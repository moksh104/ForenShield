import 'package:flutter/material.dart';

/// Card showing the user's learning streak.
///
/// - Const constructor, presentation-only, accepts days and a callback.
class LearningStreakCard extends StatelessWidget {
  /// Number of consecutive days
  final int days;

  /// Optional tap callback
  final VoidCallback? onTap;

  const LearningStreakCard({Key? key, this.days = 0, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Learning Streak', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('$days days', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                ]),
                const Spacer(),
                ElevatedButton.icon(onPressed: onTap, icon: const Icon(Icons.whatshot), label: const Text('Keep it up'), style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

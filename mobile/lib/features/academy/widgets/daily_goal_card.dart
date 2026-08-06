import 'package:flutter/material.dart';

/// Card that displays the daily learning goal progress.
///
/// - Accepts [minutesTarget] and [minutesCompleted] or a simple model-driven approach.
/// - Const constructor and presentation-only.
class DailyGoalCard extends StatelessWidget {
  /// Target minutes for the day
  final int minutesTarget;

  /// Minutes completed so far
  final int minutesCompleted;

  /// Optional tap callback
  final VoidCallback? onTap;

  const DailyGoalCard({Key? key, this.minutesTarget = 30, this.minutesCompleted = 0, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = (minutesCompleted / (minutesTarget == 0 ? 1 : minutesTarget)).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Daily Goal', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('$minutesCompleted / $minutesTarget min', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 8)),
                  ]),
                ),
                const SizedBox(width: 12),
                Column(children: [Icon(Icons.local_fire_department, color: cs.primary, size: 32), const SizedBox(height: 8), Text('${(progress * 100).round()}%', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800))])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Small progress card showing completion percentage and CTA.
class ProgressCard extends StatelessWidget {
  final double percent;
  final String label;

  const ProgressCard({Key? key, required this.percent, this.label = 'Course completion'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            SizedBox(
              width: 84,
              height: 84,
              child: Stack(alignment: Alignment.center, children: [
                CircularProgressIndicator(value: percent, strokeWidth: 8, backgroundColor: theme.colorScheme.surfaceVariant),
                Text('${(percent * 100).round()}%', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text('Keep going — complete the next lesson to progress.', style: theme.textTheme.bodyMedium)])),
            ElevatedButton(onPressed: () {}, child: const Text('Resume'))
          ]),
        ),
      ),
    );
  }
}

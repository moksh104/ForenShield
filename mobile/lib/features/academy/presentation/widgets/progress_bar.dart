import 'package:flutter/material.dart';

/// Full-width progress bar with label.
class LessonProgressBar extends StatelessWidget {
  final double progress; // 0-1
  final String? label;

  const LessonProgressBar({Key? key, required this.progress, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (label != null) Text(label!, style: theme.textTheme.bodySmall),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 8)),
      ]),
    );
  }
}

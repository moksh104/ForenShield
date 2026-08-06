import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';

/// Lesson header showing title, subtitle and progress.
class LessonHeader extends StatelessWidget {
  final LessonModel lesson;
  final double progress; // 0-1
  final VoidCallback? onBack;

  const LessonHeader({Key? key, required this.lesson, this.progress = 0.0, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(lesson.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), if (lesson.durationMinutes != null) Text('${lesson.durationMinutes} min', style: Theme.of(context).textTheme.bodySmall)])),
            const SizedBox(width: 8),
            SizedBox(width: 120, child: LinearProgressIndicator(value: progress)),
          ]),
        ),
      ),
    );
  }
}

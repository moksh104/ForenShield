import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';

/// Lessons list section. Accepts [LessonModel] list and a callback.
class LessonsSection extends StatelessWidget {
  final List<LessonModel> lessons;
  final void Function(LessonModel)? onTap;

  const LessonsSection({Key? key, this.lessons = const <LessonModel>[], this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Lessons', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        ...lessons.map((l) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: const Icon(Icons.play_arrow)),
            title: Text(l.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            subtitle: l.durationMinutes != null ? Text('${l.durationMinutes} min', style: theme.textTheme.bodySmall) : null,
            trailing: l.completed ? const Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: () => onTap?.call(l),
          );
        }).toList()
      ]),
    );
  }
}

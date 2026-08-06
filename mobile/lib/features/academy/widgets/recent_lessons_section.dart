import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// A section that shows a vertical list of recent lessons.
///
/// Accepts a list of [Lesson] and a callback for selection. No business logic.
class RecentLessonsSection extends StatelessWidget {
  final List<Lesson> lessons;
  final void Function(Lesson)? onTap;

  const RecentLessonsSection({Key? key, this.lessons = const <Lesson>[], this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lessons.map((lesson) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(color: theme.colorScheme.primary, width: 56, height: 56)),
                title: Text(lesson.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                subtitle: Text('Course • ${lesson.courseId}', style: theme.textTheme.bodySmall),
                trailing: const Icon(Icons.play_circle_outline),
                onTap: () => onTap?.call(lesson),
              ),
              const Divider()
            ],
          );
        }).toList(),
      ),
    );
  }
}

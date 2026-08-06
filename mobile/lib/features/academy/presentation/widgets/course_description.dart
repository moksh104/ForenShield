import 'package:flutter/material.dart';
import '../../models/course_model.dart';

/// Course description section.
///
/// Stateless, presentation-only. Accepts a [CourseModel] and optional onExpand callback.
class CourseDescription extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onReadMore;

  const CourseDescription({Key? key, required this.course, this.onReadMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: Text(course.subtitle.isNotEmpty ? course.subtitle : 'No description available yet.', style: theme.textTheme.bodyMedium),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(onPressed: onReadMore, child: const Text('Read more')),
        )
      ]),
    );
  }
}

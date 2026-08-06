import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// Vertical list of recommended courses.
///
/// - Accepts [courses] and an [onTap] callback. Presentation-only.
class RecommendedCoursesSection extends StatelessWidget {
  final List<Course> courses;
  final void Function(Course)? onTap;

  const RecommendedCoursesSection({Key? key, this.courses = const <Course>[], this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: courses.map((course) {
          return Material(
            color: Theme.of(context).colorScheme.surface,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: const Icon(Icons.star)),
              title: Text(course.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text(course.author ?? course.subtitle, style: Theme.of(context).textTheme.bodySmall),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onTap?.call(course),
            ),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// Horizontal featured courses section.
///
/// - Accepts a list of [Course] and a tap callback.
/// - Presentation-only and responsive; cards adapt to available width.
class FeaturedCoursesSection extends StatelessWidget {
  final List<Course> courses;
  final void Function(Course)? onCourseTap;

  const FeaturedCoursesSection({Key? key, this.courses = const <Course>[], this.onCourseTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final course = courses[index];
          return SizedBox(
            width: 260,
            child: Material(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => onCourseTap?.call(course),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Container()),
                      Text(course.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(course.subtitle, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Row(children: [Chip(label: Text(course.locked ? 'Premium' : 'Free'))])
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: courses.length,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/course_model.dart';

/// Horizontal list of related courses. Presentation-only.
class RelatedCourses extends StatelessWidget {
  final List<CourseModel> courses;
  final void Function(CourseModel)? onTap;

  const RelatedCourses({Key? key, this.courses = const <CourseModel>[], this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final course = courses[index];
          return SizedBox(
            width: 260,
            child: Material(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onTap?.call(course),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: Container()),
                    Text(course.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(course.subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ]),
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

import 'package:flutter/material.dart';
import '../../models/course_model.dart';

/// Hero banner for the course details page.
///
/// - Shows a gradient background, hero image/icon, title, subtitle and a small progress pill.
/// - Uses implicit animations and Material 3 color scheme.
class CourseDetailsHero extends StatelessWidget {
  final CourseModel course;
  final Widget? leading; // optional hero image widget

  const CourseDetailsHero({Key? key, required this.course, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [cs.primary, cs.primaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'course-hero-${course.id}',
                child: leading ?? _defaultAvatar(cs),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 350),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: cs.onPrimary, fontWeight: FontWeight.w800),
                    child: Text(course.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 8),
                  Text(course.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onPrimary.withOpacity(0.95))),
                ]),
              ),
              const SizedBox(width: 12),
              _progressPill(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultAvatar(ColorScheme cs) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: cs.onPrimary.withOpacity(0.12)),
        child: Icon(Icons.book, color: cs.onPrimary, size: 40),
      );

  Widget _progressPill(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: cs.surface.withOpacity(0.14), borderRadius: BorderRadius.circular(16)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Progress', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface)),
        const SizedBox(height: 6),
        SizedBox(width: 80, child: LinearProgressIndicator(value: course.progress)),
      ]),
    );
  }
}

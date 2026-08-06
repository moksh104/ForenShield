import 'package:flutter/material.dart';

import '../widgets/course_details_hero.dart';
import '../widgets/course_description.dart';
import '../widgets/difficulty_chip.dart';
import '../widgets/estimated_time.dart';
import '../widgets/instructor_card.dart';
import '../widgets/modules_section.dart';
import '../widgets/lessons_section.dart';
import '../widgets/progress_card.dart';
import '../widgets/related_courses.dart';
import '../../models/course_model.dart';
import '../../models/lesson_model.dart';

/// Course Details Page - UI only.
///
/// - Material 3
/// - Responsive
/// - Uses implicit animations
/// - No business logic (accepts models and callbacks)
class CourseDetailsPage extends StatelessWidget {
  final CourseModel course;
  final List<Map<String, dynamic>> modules;
  final List<LessonModel> lessons;
  final List<CourseModel> relatedCourses;
  final VoidCallback? onStart;
  final VoidCallback? onShare;

  const CourseDetailsPage({Key? key, required this.course, this.modules = const [], this.lessons = const [], this.relatedCourses = const [], this.onStart, this.onShare}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: CourseDetailsHero(course: course)),
          SliverToBoxAdapter(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SizedBox(width: 20), Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [DifficultyChip(difficulty: 'Intermediate'), const SizedBox(width: 12), EstimatedTime(duration: Duration(minutes: 90))])), IconButton(onPressed: onShare, icon: const Icon(Icons.share)), const SizedBox(width: 12)])),
          SliverToBoxAdapter(child: CourseDescription(course: course)),
          SliverToBoxAdapter(child: InstructorCard(name: 'Dr. Secure', role: 'Senior Security Engineer')),
          SliverToBoxAdapter(child: ModulesSection(modules: modules)),
          SliverToBoxAdapter(child: LessonsSection(lessons: lessons)),
          SliverToBoxAdapter(child: ProgressCard(percent: course.progress)),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Text('Related courses', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)))),
          SliverToBoxAdapter(child: RelatedCourses(courses: relatedCourses)),
          SliverToBoxAdapter(child: const SizedBox(height: 96)),
        ],
      ),

      // Sticky bottom CTA
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(course.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text('${(course.progress * 100).round()}% complete', style: theme.textTheme.bodySmall)])),
            ElevatedButton.icon(onPressed: onStart, icon: const Icon(Icons.play_arrow), label: const Text('Start Learning'), style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)))
          ]),
        ),
      ),
    );
  }
}

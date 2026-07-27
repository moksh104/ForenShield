import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../utils/academy_utils.dart';

/// A card widget representing a single course in the Academy course list.
///
/// Fully decoupled from providers — accepts a [CourseModel] and callbacks.
class ModuleCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final difficultyColor = _difficultyColor(course.difficulty);

    return Semantics(
      label: 'Course: ${course.title}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: difficultyColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        AcademyUtils.difficultyLabel(course.difficulty)
                            .toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: difficultyColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AcademyUtils.formatDuration(course.estimatedMinutes),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  course.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  course.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progress,
                    minHeight: 4,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerLowest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${course.completedModules}/${course.totalModules} modules',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${course.totalXp} XP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(CourseDifficulty difficulty) {
    switch (difficulty) {
      case CourseDifficulty.beginner:
        return const Color(0xFF34D399);
      case CourseDifficulty.intermediate:
        return const Color(0xFFFBBF24);
      case CourseDifficulty.advanced:
        return const Color(0xFFF87171);
    }
  }
}

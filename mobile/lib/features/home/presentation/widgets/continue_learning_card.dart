import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../routes/route_constants.dart';
import '../../../academy/providers/lesson_providers.dart';
import '../../../academy/models/course_model.dart';

class ContinueLearningCard extends ConsumerWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    final coursesAsync = ref.watch(coursesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue Learning',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          coursesAsync.when(
            data: (result) {
              return result.when(
                success: (courses) {
                  if (courses.isEmpty) return _buildEmptyState(context, foren);
                  // TODO: Fetch the actual "in-progress" course for the user.
                  // Currently pulling the first course as a placeholder for "continue".
                  final course = courses.first;
                  return _buildCourseCard(context, theme, foren, course);
                },
                failure: (_) => _buildEmptyState(context, foren),
              );
            },
            loading: () => _buildLoadingState(theme, foren),
            error: (err, stack) => _buildEmptyState(context, foren),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    ThemeData theme,
    ForenColors foren,
    CourseModel course,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.push('${RouteConstants.courseDetail}/${course.id}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        decoration: BoxDecoration(
          color: foren.surfaceRaised1,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: foren.borderSubtle, width: 1),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    // TODO: Connect actual course progress data when available
                    'Continue learning',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foren.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ForenColors foren) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: foren.surfaceRaised1,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: foren.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 48, color: foren.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Ready to start learning?',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Check out the Cyber Academy to begin your journey.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: foren.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => context.push(RouteConstants.academy),
            child: const Text('Go to Academy'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, ForenColors foren) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: foren.surfaceRaised1,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: foren.borderSubtle, width: 1),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../providers/course_provider.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/course_card.dart';

/// Main Cyber Academy Course List Screen.
class CourseListScreen extends ConsumerWidget {
  const CourseListScreen({super.key});

  static const List<String> _categories = [
    'All',
    'Memory Forensics',
    'Reverse Engineering',
    'Network Defense',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final state = ref.watch(courseProvider);
    final notifier = ref.read(courseProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Cyber Academy',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CategoryFilterBar(
              categories: _categories,
              selectedCategory: state.selectedCategory,
              onCategorySelected: (cat) => notifier.filterCategory(cat),
              onSearchSubmitted: (q) => notifier.search(q),
              onProgressTap: () => context.push(RouteConstants.academyProgress),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _buildCourseContent(context, ref, state, notifier, foren),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseContent(
    BuildContext context,
    WidgetRef ref,
    CourseState state,
    CourseNotifier notifier,
    ForenColors foren,
  ) {
    final theme = Theme.of(context);
    final academyColor = foren.academy.t500;

    switch (state.status) {
      case CourseStatus.initial:
      case CourseStatus.loading:
        return Center(
          child: CircularProgressIndicator(color: academyColor),
        );

      case CourseStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: foren.critical.t500, size: 48),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage ?? 'Failed to load courses.',
                style: TextStyle(color: foren.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => notifier.loadCourses(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: academyColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case CourseStatus.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_outlined,
                color: foren.textDisabled,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No courses found matching criteria.',
                style: TextStyle(color: foren.textDisabled),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  notifier.filterCategory('All');
                  notifier.search('');
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        );

      case CourseStatus.refreshing:
      case CourseStatus.success:
        return RefreshIndicator(
          onRefresh: () => notifier.refreshCourses(),
          color: academyColor,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: state.courses.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final course = state.courses[index];
              return CourseCard(
                course: course,
                onTap: () {
                  context.push('${RouteConstants.courseDetail}/${course.id}');
                },
                onContinueTap: () {
                  context.push('${RouteConstants.courseDetail}/${course.id}');
                },
              );
            },
          ),
        );
    }
  }
}

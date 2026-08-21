import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../../core/components/foren_navigation.dart';
import '../../../../shared/widgets/foren_brand_header.dart';
import '../../presentation/providers/course_provider.dart';
import '../../../../shared/states/empty_state.dart';
import '../../../../shared/states/error_state.dart';
import '../../../../shared/states/loading_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/course_card.dart';

/// Cyber Academy Screen matching exact white-theme design spec screenshot.
class CourseListScreen extends ConsumerWidget {
  const CourseListScreen({super.key});

  static const List<String> _categories = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurfaceVariant;
    final foren = theme.extension<ForenColors>()!;

    final state = ref.watch(courseProvider);
    final notifier = ref.read(courseProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: ForenBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteConstants.missionControl);
              break;
            case 1:
              break;
            case 2:
              context.go(RouteConstants.simulation);
              break;
            case 3:
              context.go(RouteConstants.investigation);
              break;
            case 4:
              context.go(RouteConstants.profile);
              break;
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Top Header Bar: Back + Logo + Search & Notif ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.lg,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: textPrimary,
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go(RouteConstants.missionControl);
                      }
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  // Shared Brand Header
                  const ForenShieldBrandHeader(),

                  const Spacer(),

                  // Search Button
                  GestureDetector(
                    onTap: () => _showSearchBottomSheet(context, ref),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.search_rounded,
                        size: 22,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  // Notification Bell
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.notifications),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.notifications_none_outlined,
                            size: 22,
                            color: textPrimary,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── 2. Title Section + My Courses Button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cyber Academy',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Learn cybersecurity with interactive lessons and quizzes.',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  // My Courses Button
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.academyProgress),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: AppRadius.borderRadiusSm,
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_outline_rounded,
                            size: 16,
                            color: textPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'My Courses',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── 3. Category Filter Bar (All, Beginner, Intermediate, Advanced) ──
            CategoryFilterBar(
              categories: _categories,
              selectedCategory: state.selectedCategory,
              onCategorySelected: (cat) => notifier.filterCategory(cat),
              onFilterTap: () {},
            ),

            const SizedBox(height: AppSpacing.md),

            // ── 4. Courses List View ──
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
    switch (state.status) {
      case CourseStatus.initial:
      case CourseStatus.loading:
        return const LoadingState(message: 'Loading courses...');

      case CourseStatus.error:
        return ErrorState(
          title: 'Network Error',
          message: state.errorMessage ?? 'Failed to load courses.',
          onRetry: () => notifier.refreshCourses(),
        );

      case CourseStatus.empty:
        return EmptyState(
          title: 'No Courses Found',
          message: 'Try adjusting your filters or search query.',
          icon: Icons.search_off_outlined,
          actionLabel: 'Clear Filters',
          onAction: () {
            notifier.filterCategory('All');
            notifier.search('');
          },
        );

      case CourseStatus.refreshing:
      case CourseStatus.success:
        final inProgressCourses = state.courses
            .where(
              (c) =>
                  c.isEnrolled &&
                  c.completionPercentage > 0 &&
                  c.completionPercentage < 1.0,
            )
            .toList();

        return RefreshIndicator(
          onRefresh: () => notifier.refreshCourses(),
          color: Theme.of(context).colorScheme.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              if (inProgressCourses.isNotEmpty &&
                  state.selectedCategory == 'All' &&
                  state.searchQuery.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    'Continue Learning',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                CourseCard(
                  course: inProgressCourses.first,
                  onTap: () {
                    context.push(
                      '${RouteConstants.courseDetail}/${inProgressCourses.first.id}',
                    );
                  },
                  onContinueTap: () {
                    context.push(
                      '${RouteConstants.courseDetail}/${inProgressCourses.first.id}',
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    'Course Catalog',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              ...state.courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: CourseCard(
                    course: course,
                    onTap: () {
                      context.push(
                        '${RouteConstants.courseDetail}/${course.id}',
                      );
                    },
                    onContinueTap: () {
                      context.push(
                        '${RouteConstants.courseDetail}/${course.id}',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  void _showSearchBottomSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.read(courseProvider);
    final courses = state.courses;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = courses
                .where(
                  (c) =>
                      c.title.toLowerCase().contains(query.toLowerCase()) ||
                      c.description.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              minChildSize: 0.3,
              builder: (_, controller) => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search courses...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setModalState(() => query = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${filtered.length} results',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: ListView.separated(
                        controller: controller,
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final c = filtered[i];
                          return ListTile(
                            title: Text(
                              c.title,
                              style: theme.textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              c.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              context.push(
                                '${RouteConstants.courseDetail}/${c.id}',
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

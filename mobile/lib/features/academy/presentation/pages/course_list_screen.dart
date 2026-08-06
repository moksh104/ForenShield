import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../../core/components/foren_navigation.dart';
import '../providers/course_provider.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final textPrimary = isDark
        ? AppColors.textPrimary
        : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? AppColors.textSecondary
        : const Color(0xFF64748B);
    final foren = theme.extension<ForenColors>()!;

    final state = ref.watch(courseProvider);
    final notifier = ref.read(courseProvider.notifier);

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFFAFAFC),
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
                  const SizedBox(width: 4),

                  // Brand Shield Logo Mark
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.surface
                          : AppColors.lightSurface,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, Color(0xFF1D4ED8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              Text(
                                'F',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Brand Name + Tagline
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'FOREN',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            'SHIELD',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'LEARN · INVESTIGATE · DEFEND',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Search Button
                  GestureDetector(
                    onTap: () {},
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
                  const SizedBox(width: 4),

                  // Notification Bell
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.settings),
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
                                color: isDark
                                    ? theme.scaffoldBackgroundColor
                                    : Colors.white,
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
                        const SizedBox(height: 4),
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

                  const SizedBox(width: 12),

                  // My Courses Button
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.academyProgress),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface : Colors.white,
                        borderRadius: AppRadius.borderRadiusSm,
                        border: Border.all(
                          color: isDark
                              ? foren.borderSubtle
                              : const Color(0xFFE2E8F0),
                        ),
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
    final primaryColor = AppColors.primary;

    switch (state.status) {
      case CourseStatus.initial:
      case CourseStatus.loading:
        return Center(child: CircularProgressIndicator(color: primaryColor));

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
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
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
          color: primaryColor,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
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

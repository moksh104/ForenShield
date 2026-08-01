import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../domain/entities/course_entity.dart';
import '../providers/course_provider.dart';

/// Course Details Screen showing syllabus, prerequisites, learning outcomes, and start CTA.
class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  CourseEntity? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseDetail();
  }

  Future<void> _loadCourseDetail() async {
    final repo = ref.read(courseRepositoryProvider);
    final result = await repo.getCourseDetail(widget.courseId);
    result.when(
      success: (data) {
        if (mounted) {
          setState(() {
            _course = data;
            _isLoading = false;
          });
        }
      },
      failure: (_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: academyColor),
        ),
      );
    }

    final course = _course;
    if (course == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.scaffoldBackgroundColor),
        body: Center(
          child: Text('Course not found.', style: TextStyle(color: foren.textDisabled)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar & Banner Header
                  SliverAppBar(
                    expandedHeight: 180,
                    pinned: true,
                    backgroundColor: theme.colorScheme.surface,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.bgBase, theme.colorScheme.surface],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: academyColor.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      color: theme.colorScheme.onSurface,
                      onPressed: () => context.pop(),
                    ),
                  ),

                  // Metadata Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Instructor: ${course.instructorName} · ${course.difficulty}',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            course.description,
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Learning Outcomes
                          Text(
                            'Learning Outcomes',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ...course.learningOutcomes.map(
                            (o) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 14, color: foren.success.t500),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      o,
                                      style: TextStyle(
                                        color: foren.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Modules Syllabus
                          Text(
                            'Course Syllabus',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ...course.modules.map(
                            (m) => _ModuleExpansionTile(
                              module: m,
                              onLessonTap: (lesId) {
                                context.push('${RouteConstants.lessonPlayer}/$lesId');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Start / Continue CTA Bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: foren.borderSubtle),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final firstLessonId = course.modules.isNotEmpty &&
                            course.modules.first.lessons.isNotEmpty
                        ? course.modules.first.lessons.first.id
                        : 'les_101';
                    context.push('${RouteConstants.lessonPlayer}/$firstLessonId');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: academyColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  child: Text(
                    course.completionPercentage > 0
                        ? 'Continue Learning'
                        : 'Start Course',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleExpansionTile extends StatelessWidget {
  final ModuleEntity module;
  final ValueChanged<String> onLessonTap;

  const _ModuleExpansionTile({
    required this.module,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        title: Text(
          module.title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          '${module.lessons.length} Lessons',
          style: TextStyle(color: foren.textDisabled, fontSize: 11),
        ),
        children: module.lessons.map((les) {
          return ListTile(
            dense: true,
            leading: Icon(
              les.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
              color: les.isCompleted ? foren.success.t500 : foren.academy.t500,
              size: 18,
            ),
            title: Text(
              les.title,
              style: TextStyle(
                color: les.isCompleted
                    ? foren.textDisabled
                    : theme.colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
            trailing: Text(
              '${les.durationMinutes}m',
              style: TextStyle(color: foren.textDisabled, fontSize: 10),
            ),
            onTap: () => onLessonTap(les.id),
          );
        }).toList(),
      ),
    );
  }
}

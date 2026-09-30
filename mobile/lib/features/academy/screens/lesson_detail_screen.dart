import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/app_error_messages.dart';
import '../providers/lesson_providers.dart';
import '../utils/academy_utils.dart';

/// A screen showing the content and metadata for a single lesson.
///
/// Receives [lessonId] via GoRouter and watches the lesson detail provider.
class LessonDetailScreen extends ConsumerWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonDetailProvider(lessonId));
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        leading: BackButton(color: theme.colorScheme.onSurface),
      ),
      body: lessonAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              AppErrorMessages.from(err, context: AppErrorContext.academy),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        data: (result) {
          return result.when(
            success: (lesson) => SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          AcademyUtils.contentTypeLabel(lesson.contentType),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${lesson.durationMinutes} min',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      if (lesson.isCompleted)
                        Chip(label: const Text('Completed'))
                      else if (lesson.isLocked)
                        Chip(label: const Text('Locked')),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    lesson.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Text(
                        '+${lesson.xpReward} XP',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        lesson.isLocked
                            ? 'Unlock previous lessons first'
                            : 'Ready to learn',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (!lesson.isLocked)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Starting "${lesson.title}"...'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Start Lesson'),
                      ),
                    ),
                ],
              ),
            ),
            failure: (_) => const Center(child: Text('Failed to load lesson.')),
          );
        },
      ),
    );
  }
}

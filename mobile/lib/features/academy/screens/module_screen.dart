import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lesson_providers.dart';
import '../utils/academy_utils.dart';

/// A screen showing all modules and lessons for a specific course.
///
/// Receives [courseId] via GoRouter and watches the course detail provider.
class ModuleScreen extends ConsumerWidget {
  final String courseId;

  const ModuleScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: courseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (result) {
          return result.when(
            success: (course) => SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButton(color: theme.colorScheme.onSurface),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            course.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      course.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('${course.totalModules} modules')),
                        Chip(label: Text('${course.totalXp} XP')),
                        Chip(
                          label: Text(
                            AcademyUtils.difficultyLabel(course.difficulty),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: course.progress,
                        minHeight: 6,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(course.progress * 100).toStringAsFixed(0)}% complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Modules',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...course.modules.map(
                      (module) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              module.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              module.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              '${(module.progress * 100).toStringAsFixed(0)}%',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            failure: (_) => const Center(child: Text('Failed to load course.')),
          );
        },
      ),
    );
  }
}

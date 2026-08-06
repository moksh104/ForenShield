import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../utils/academy_utils.dart';

/// A list tile representing a single [LessonModel].
///
/// Shows completion state, content type icon, duration, and XP reward.
/// Fully decoupled from providers — accepts a [LessonModel] and callbacks.
class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback? onTap;

  const LessonTile({super.key, required this.lesson, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLocked = lesson.isLocked;

    return Semantics(
      label: isLocked
          ? 'Lesson locked: ${lesson.title}'
          : '${lesson.isCompleted ? "Completed" : "Start"} lesson: ${lesson.title}',
      button: !isLocked,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _LessonStatusIcon(lesson: lesson),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isLocked
                            ? theme.colorScheme.onSurface.withValues(
                                alpha: 0.35,
                              )
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          AcademyUtils.contentTypeLabel(lesson.contentType),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: isLocked ? 0.25 : 0.5,
                            ),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AcademyUtils.formatDuration(lesson.durationMinutes),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: isLocked ? 0.25 : 0.5,
                            ),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (!isLocked)
                Text(
                  '+${lesson.xpReward} XP',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: lesson.isCompleted
                        ? Colors.greenAccent.shade400
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              if (isLocked)
                Icon(
                  Icons.lock_outline,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonStatusIcon extends StatelessWidget {
  final LessonModel lesson;
  const _LessonStatusIcon({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (lesson.isLocked) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.lock_outline,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
        ),
      );
    }

    if (lesson.isCompleted) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.greenAccent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.check_rounded,
          size: 18,
          color: Colors.greenAccent.shade400,
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${lesson.order}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

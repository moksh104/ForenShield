import 'package:flutter/material.dart';

/// A card showing the user's current learning progress.
///
/// Accepts lesson title, progress (0.0–1.0), and callbacks.
class ContinueLearningCard extends StatelessWidget {
  final String lessonTitle;
  final String moduleTitle;
  final double progress; // 0.0 – 1.0
  final String timeRemaining;
  final VoidCallback? onResumeTap;

  const ContinueLearningCard({
    super.key,
    this.lessonTitle = 'Digital Forensics: Evidence Collection',
    this.moduleTitle = 'Module 3 · Disk Imaging',
    this.progress = 0.62,
    this.timeRemaining = '18 min left',
    this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Semantics(
        label: 'Continue learning: $lessonTitle',
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: InkWell(
            onTap: onResumeTap,
            borderRadius: BorderRadius.circular(20),
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
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.school_outlined,
                                size: 11,
                                color: theme.colorScheme.onPrimaryContainer),
                            const SizedBox(width: 4),
                            Text(
                              'ACADEMY',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeRemaining,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lessonTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    moduleTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: theme.colorScheme.surfaceContainerLowest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${(progress * 100).toInt()}% complete',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Resume →',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

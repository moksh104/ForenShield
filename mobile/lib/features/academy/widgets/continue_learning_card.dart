import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// A reusable continue-learning card.
///
/// - Presentation-only; accepts a [Course] and callbacks for interactions.
/// - Const constructor for maximum reuse.
/// - Responsive layout: compresses on narrow screens and expands on wide ones.
class ContinueLearningCard extends StatelessWidget {
  /// The course to display progress for
  final Course course;

  /// The currently active lesson title (optional)
  final String? lessonTitle;

  /// Callback when play button is tapped
  final VoidCallback? onPlay;

  /// Callback when the whole card is tapped
  final VoidCallback? onTap;

  const ContinueLearningCard({Key? key, required this.course, this.lessonTitle, this.onPlay, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              return Row(
                children: [
                  Container(
                    width: isNarrow ? 56 : 72,
                    height: isNarrow ? 56 : 72,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: LinearGradient(colors: [cs.primary, cs.secondary])),
                    child: Icon(Icons.computer, color: cs.onPrimary, size: isNarrow ? 24 : 36),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(course.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(lessonTitle ?? course.subtitle, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: course.progress, minHeight: 8)),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  IconButton(onPressed: onPlay, icon: Icon(Icons.play_circle_fill, color: cs.primary, size: isNarrow ? 28 : 36)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

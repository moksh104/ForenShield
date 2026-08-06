import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// A reusable achievement/progress card displaying badge progress.
///
/// - Accepts an [Achievement] model and a tap callback.
/// - All constructors are const and the widget contains no business logic.
class AchievementProgressCard extends StatelessWidget {
  /// Achievement model to display progress for
  final Achievement achievement;

  /// Tap callback when the card is pressed
  final VoidCallback? onTap;

  const AchievementProgressCard({Key? key, required this.achievement, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return isWide
                  ? Row(children: [_circle(theme), const SizedBox(width: 18), Expanded(child: _details(theme))])
                  : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_circle(theme), const SizedBox(height: 12), _details(theme)]);
            }),
          ),
        ),
      ),
    );
  }

  Widget _circle(ThemeData theme) => SizedBox(
        width: 110,
        height: 110,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: achievement.progress, strokeWidth: 10, backgroundColor: theme.colorScheme.surfaceVariant),
            Column(mainAxisSize: MainAxisSize.min, children: [Text('${(achievement.progress * 100).round()}%', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), Text(achievement.name, style: theme.textTheme.bodySmall)])
          ],
        ),
      );

  Widget _details(ThemeData theme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${achievement.name}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(achievement.description, style: theme.textTheme.bodyMedium)]);
}

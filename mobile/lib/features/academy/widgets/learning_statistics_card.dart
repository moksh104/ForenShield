import 'package:flutter/material.dart';
import '../models/academy_models.dart';

/// A compact, responsive statistics card showing high-level learning metrics.
///
/// Accepts plain integers and renders using Material 3 theming. No business logic.
class LearningStatisticsCard extends StatelessWidget {
  /// Total learning hours
  final int totalHours;

  /// Number of completed courses
  final int completedCourses;

  /// Active learning paths
  final int activePaths;

  /// Optional tap callback
  final VoidCallback? onTap;

  const LearningStatisticsCard({
    Key? key,
    this.totalHours = 0,
    this.completedCourses = 0,
    this.activePaths = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Material(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_statItem(context, 'Hours', '$totalHours h'), _statItem(context, 'Courses', '$completedCourses'), _statItem(context, 'Paths', '$activePaths')],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [_statItem(context, 'Hours', '$totalHours h'), const Spacer(), _statItem(context, 'Courses', '$completedCourses')]),
                  const SizedBox(height: 12),
                  _statItem(context, 'Active paths', '$activePaths'),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _statItem(BuildContext context, String label, String value) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}

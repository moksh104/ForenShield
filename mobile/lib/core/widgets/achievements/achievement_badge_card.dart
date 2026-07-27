import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_motion.dart';
import '../../theme/foren_theme.dart';

class AchievementBadgeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final double progress;
  final Color color;

  const AchievementBadgeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return SizedBox(
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: theme.colorScheme.surface,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.95),
                          color.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    unlocked ? Icons.check_circle : Icons.lock,
                    color: unlocked
                        ? foren.success.t500
                        : foren.textSecondary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: foren.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
                duration: AppMotion.normal,
                curve: AppMotion.standard,
                builder: (context, animatedValue, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: animatedValue,
                      color: color,
                      backgroundColor: foren.surfaceRaised1,
                      minHeight: 8,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_motion.dart';
import '../../theme/foren_theme.dart';
import '../progress/xp_progress_bar.dart';

class AchievementOverviewCard extends StatelessWidget {
  final String rankLabel;
  final int currentLevel;
  final int currentXp;
  final int xpForNextLevel;
  final double levelProgress;
  final int streakDays;
  final double completionPercent;

  const AchievementOverviewCard({
    super.key,
    required this.rankLabel,
    required this.currentLevel,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.levelProgress,
    required this.streakDays,
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievement Overview', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Rank: $rankLabel',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AchievementProgressTile(
              label: 'Level Progress',
              value: levelProgress,
              valueText: '${(levelProgress * 100).toInt()}%',
              accentColor: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _buildStatChip(
                  context,
                  Icons.flash_on,
                  '$streakDays-day streak',
                  'Learning streak',
                ),
                _buildStatChip(
                  context,
                  Icons.check_circle_outline,
                  '${(completionPercent * 100).toInt()}%',
                  'Completion',
                ),
                _buildStatChip(context, Icons.school, '$currentXp XP', 'Total XP'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            XPProgressBar(
              currentXP: currentXp,
              targetXP: xpForNextLevel,
              currentLevel: currentLevel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: foren.surfaceRaised1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: foren.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class AchievementProgressTile extends StatelessWidget {
  final String label;
  final double value;
  final String valueText;
  final Color accentColor;

  const AchievementProgressTile({
    super.key,
    required this.label,
    required this.value,
    required this.valueText,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Text(
              valueText,
              style: theme.textTheme.labelLarge?.copyWith(color: accentColor),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: value.clamp(0.0, 1.0)),
          duration: AppMotion.slow,
          curve: AppMotion.standard,
          builder: (context, animatedValue, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: animatedValue,
                color: accentColor,
                backgroundColor: foren.surfaceRaised1,
                minHeight: 10,
              ),
            );
          },
        ),
      ],
    );
  }
}

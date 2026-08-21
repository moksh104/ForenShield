import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/xp_config.dart';
import 'xp_progress_bar.dart';
import 'streak_indicator.dart';

/// Current user stats card at the top of the leaderboard screen.
class LeaderboardCard extends StatelessWidget {
  final LeaderboardEntryModel entry;
  final int myRank;
  final int totalPlayers;

  const LeaderboardCard({
    super.key,
    required this.entry,
    required this.myRank,
    required this.totalPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final level = XpConfig.levelForXp(entry.xp);
    final levelTitle = XpConfig.levelTitle(level);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.15),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Rank + Name Row
          Row(
            children: [
              // Rank badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '#$myRank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.username,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Level $level · $levelTitle',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              StreakIndicator(streak: entry.streak),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // XP Progress Bar
          XpProgressBar(xp: entry.xp),

          const SizedBox(height: AppSpacing.md),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(
                label: 'XP',
                value: '${entry.xp}',
                color: theme.colorScheme.primary,
              ),
              _StatChip(
                label: 'Courses',
                value: '${entry.completedCourses}',
                color: foren.academy.t500,
              ),
              _StatChip(
                label: 'Cases',
                value: '${entry.completedCases}',
                color: foren.investigation.t500,
              ),
              _StatChip(
                label: 'of $totalPlayers',
                value: '#$myRank',
                color: foren.success.t500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color:
                Theme.of(context).extension<ForenColors>()?.textSecondary ??
                Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

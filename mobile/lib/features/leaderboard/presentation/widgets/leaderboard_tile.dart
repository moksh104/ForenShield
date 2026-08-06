import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/xp_config.dart';
import 'rank_badge.dart';

/// Single row tile in the leaderboard list.
class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntryModel entry;
  final bool isCurrentUser;

  const LeaderboardTile({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    final level = XpConfig.levelForXp(entry.xp);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? theme.colorScheme.primary.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3))
            : Border.all(color: foren.borderSubtle),
      ),
      child: Row(
        children: [
          // Rank badge
          RankBadge(rank: entry.rank),
          const SizedBox(width: AppSpacing.md),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: foren.surfaceRaised2,
            backgroundImage: entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty
                ? NetworkImage(entry.avatarUrl!)
                : null,
            child: entry.avatarUrl == null || entry.avatarUrl!.isEmpty
                ? Text(
                    entry.username.isNotEmpty
                        ? entry.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),

          // Name + Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.username,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: isCurrentUser ? FontWeight.w800 : FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Level $level · ${XpConfig.levelTitle(level)}',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.xp} XP',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (entry.streak > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 2),
                    Text(
                      '${entry.streak}d',
                      style: TextStyle(
                        color: foren.warning.t500,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

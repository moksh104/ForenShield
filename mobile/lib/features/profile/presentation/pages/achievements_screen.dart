import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../providers/profile_provider.dart';

/// Achievements Wall Screen.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final warningColor = foren.warning.t500;

    final state = ref.watch(profileProvider);
    final profile = state.profile;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Achievements & Badges',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: profile == null
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Header Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: AppRadius.borderRadiusLg,
                        border: Border.all(
                          color: warningColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _AchieveStat(
                            label: 'Badges Earned',
                            value: '${profile.badges.where((b) => b.isUnlocked).length}',
                          ),
                          _AchieveStat(
                            label: 'Total XP',
                            value: '${profile.xpPoints}',
                          ),
                          _AchieveStat(
                            label: 'Level',
                            value: 'Lvl ${profile.level}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Unlocked Badges Section
                    Text(
                      'Earned Badges',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (profile.badges.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: foren.borderSubtle.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events_outlined,
                                size: 40, color: foren.textDisabled),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'No Achievements Unlocked Yet',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complete courses, quizzes, and forensic investigation cases to earn specialist badges.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: foren.textDisabled,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...profile.badges.map(
                        (b) => Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: AppRadius.borderRadiusMd,
                            border: Border.all(
                              color: b.isUnlocked
                                  ? warningColor.withValues(alpha: 0.4)
                                  : foren.borderSubtle.withValues(alpha: 0.3),
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: b.isUnlocked
                                    ? warningColor.withValues(alpha: 0.15)
                                    : foren.surfaceRaised1,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                b.isUnlocked ? Icons.military_tech : Icons.lock_outline,
                                color: b.isUnlocked
                                    ? warningColor
                                    : foren.textDisabled,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              b.title,
                              style: TextStyle(
                                color: b.isUnlocked
                                    ? theme.colorScheme.onSurface
                                    : foren.textDisabled,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              b.description,
                              style: TextStyle(
                                color: foren.textDisabled,
                                fontSize: 11,
                              ),
                            ),
                            trailing: Text(
                              '+${b.xpReward} XP',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),

                    // XP Activity History Log
                    Text(
                      'Recent XP Log',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ...profile.xpHistory.map(
                      (xp) => Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: foren.borderSubtle.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bolt, color: primaryColor, size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    xp.title,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${xp.source} · ${xp.timestamp}',
                                    style: TextStyle(
                                      color: foren.textDisabled,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+${xp.xpAmount} XP',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AchieveStat extends StatelessWidget {
  final String label;
  final String value;

  const _AchieveStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: foren.textDisabled,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

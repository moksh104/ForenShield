import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../providers/profile_provider.dart';

/// Achievements & Badge Vault Screen.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final state = ref.watch(profileProvider);
    final profile = state.profile;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Achievements & Badge Vault',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 40,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            SafeArea(
              child: profile == null
                  ? Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Summary Header Card
                          GlassEffect(
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.4),
                              width: 1.0,
                            ),
                            borderRadius: AppRadius.borderRadiusLg,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _AchieveStat(
                                    label: 'Badges earned',
                                    value:
                                        '${profile.badges.where((b) => b.isUnlocked).length}',
                                    color: primaryColor,
                                  ),
                                  _AchieveStat(
                                    label: 'Total XP',
                                    value: '${profile.xpPoints}',
                                    color: primaryColor,
                                  ),
                                  _AchieveStat(
                                    label: 'Level',
                                    value: 'Lvl ${profile.level}',
                                    color: foren.success.t500,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // 2. Earned Badges Section Title
                          Text(
                            'Specialist badges',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: foren.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.xs),

                          if (profile.badges.isEmpty)
                            GlassEffect(
                              border: Border.all(
                                color: foren.borderSubtle.withValues(
                                  alpha: 0.4,
                                ),
                                width: 1.0,
                              ),
                              borderRadius: AppRadius.borderRadiusMd,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 44,
                                      color: foren.textSecondary,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'No achievements unlocked yet',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Complete courses, quizzes, and forensic investigation cases to earn specialist badges.',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: foren.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...profile.badges.asMap().entries.map((entry) {
                              final b = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.xs,
                                ),
                                child: _BadgeTile(badge: b),
                              );
                            }),

                          const SizedBox(height: AppSpacing.lg),

                          // 3. XP Activity History Log Title
                          Text(
                            'Recent XP log',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: foren.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.xs),

                          ...profile.xpHistory.asMap().entries.map((entry) {
                            final xp = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.xs,
                              ),
                              child: GlassEffect(
                                border: Border.all(
                                  color: foren.borderSubtle.withValues(
                                    alpha: 0.4,
                                  ),
                                  width: 1.0,
                                ),
                                borderRadius: AppRadius.borderRadiusMd,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.bolt,
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              xp.title,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              '${xp.source} · ${xp.timestamp}',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: foren.textSecondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(
                                            alpha: 0.15,
                                          ),
                                          borderRadius:
                                              AppRadius.borderRadiusSm,
                                          border: Border.all(
                                            color: primaryColor.withValues(
                                              alpha: 0.4,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '+${xp.xpAmount} XP',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchieveStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AchieveStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: foren.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatefulWidget {
  final dynamic badge;

  const _BadgeTile({required this.badge});

  @override
  State<_BadgeTile> createState() => _BadgeTileState();
}

class _BadgeTileState extends State<_BadgeTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final b = widget.badge;

    final Widget badgeTileBody = GlassEffect(
      border: Border.all(
        color: _isHovered
            ? primaryColor
            : (b.isUnlocked
                  ? primaryColor.withValues(alpha: 0.4)
                  : foren.borderSubtle.withValues(alpha: 0.3)),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusMd,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: b.isUnlocked
                ? primaryColor.withValues(alpha: 0.20)
                : foren.surfaceRaised1,
            shape: BoxShape.circle,
            border: Border.all(
              color: b.isUnlocked ? primaryColor : foren.borderSubtle,
              width: 1,
            ),
          ),
          child: Icon(
            b.isUnlocked ? Icons.military_tech : Icons.lock_outline,
            color: b.isUnlocked ? primaryColor : foren.textSecondary,
            size: 20,
          ),
        ),
        title: Text(
          b.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: b.isUnlocked
                ? theme.colorScheme.onSurface
                : foren.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          b.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: foren.textSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderRadiusSm,
            border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            '+${b.xpReward} XP',
            style: theme.textTheme.labelMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
        child: badgeTileBody,
      ),
    );
  }
}

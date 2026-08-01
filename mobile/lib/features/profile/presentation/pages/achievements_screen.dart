import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
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
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Geist',
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 40,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            const Positioned.fill(child: BackgroundGrid()),
            SafeArea(
              child: profile == null
                  ? Center(child: CircularProgressIndicator(color: primaryColor))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Summary Header Card
                          GlassEffect(
                            blurX: 14.0,
                            blurY: 14.0,
                            opacity: 0.12,
                            border: Border.all(
                              color: AppColors.logoGold.withValues(alpha: 0.4),
                              width: 1.0,
                            ),
                            borderRadius: AppRadius.borderRadiusLg,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _AchieveStat(
                                    label: 'BADGES EARNED',
                                    value: '${profile.badges.where((b) => b.isUnlocked).length}',
                                    color: AppColors.logoGold,
                                  ),
                                  _AchieveStat(
                                    label: 'TOTAL XP',
                                    value: '${profile.xpPoints}',
                                    color: primaryColor,
                                  ),
                                  _AchieveStat(
                                    label: 'LEVEL',
                                    value: 'Lvl ${profile.level}',
                                    color: foren.success.t500,
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.1, end: 0),

                          const SizedBox(height: AppSpacing.lg),

                          // 2. Earned Badges Section Title
                          Text(
                            'SPECIALIST BADGES & VAULT',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              letterSpacing: 1.0,
                            ),
                          )
                              .animate(delay: 100.ms)
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.xs),

                          if (profile.badges.isEmpty)
                            GlassEffect(
                              blurX: 12.0,
                              blurY: 12.0,
                              opacity: 0.10,
                              border: Border.all(
                                color: foren.borderSubtle.withValues(alpha: 0.4),
                                width: 1.0,
                              ),
                              borderRadius: AppRadius.borderRadiusMd,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  children: [
                                    Icon(Icons.emoji_events_outlined, size: 44, color: foren.textSecondary),
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
                                        color: foren.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...profile.badges.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final b = entry.value;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                  child: _BadgeTile(badge: b)
                                      .animate(delay: Duration(milliseconds: 150 + (index * 80)))
                                      .fadeIn(duration: 400.ms)
                                      .slideX(begin: -0.05, end: 0),
                                );
                              },
                            ),

                          const SizedBox(height: AppSpacing.lg),

                          // 3. XP Activity History Log Title
                          Text(
                            'RECENT XP LOG & TELEMETRY',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              letterSpacing: 1.0,
                            ),
                          )
                              .animate(delay: 350.ms)
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.xs),

                          ...profile.xpHistory.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final xp = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                child: GlassEffect(
                                  blurX: 10.0,
                                  blurY: 10.0,
                                  opacity: 0.10,
                                  border: Border.all(
                                    color: foren.borderSubtle.withValues(alpha: 0.4),
                                    width: 1.0,
                                  ),
                                  borderRadius: AppRadius.borderRadiusMd,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSpacing.sm),
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
                                                  color: foren.textSecondary,
                                                  fontSize: 10,
                                                  fontFamily: 'monospace',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(alpha: 0.15),
                                            borderRadius: AppRadius.borderRadiusSm,
                                            border: Border.all(
                                              color: primaryColor.withValues(alpha: 0.4),
                                            ),
                                          ),
                                          child: Text(
                                            '+${xp.xpAmount} XP',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    .animate(delay: Duration(milliseconds: 400 + (index * 80)))
                                    .fadeIn(duration: 400.ms)
                                    .slideX(begin: -0.05, end: 0),
                              );
                            },
                          ),
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
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Geist',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: foren.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
            letterSpacing: 0.5,
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
      blurX: 10.0,
      blurY: 10.0,
      opacity: 0.10,
      border: Border.all(
        color: _isHovered
            ? AppColors.logoGold
            : (b.isUnlocked ? AppColors.logoGold.withValues(alpha: 0.4) : foren.borderSubtle.withValues(alpha: 0.3)),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusMd,
      child: ListTile(
        leading: GlowEffect(
          glowColor: b.isUnlocked ? AppColors.logoGold : Colors.transparent,
          blurRadius: 10,
          animate: b.isUnlocked,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: b.isUnlocked
                  ? AppColors.logoGold.withValues(alpha: 0.20)
                  : foren.surfaceRaised1,
              shape: BoxShape.circle,
              border: Border.all(
                color: b.isUnlocked ? AppColors.logoGold : foren.borderSubtle,
                width: 1,
              ),
            ),
            child: Icon(
              b.isUnlocked ? Icons.military_tech : Icons.lock_outline,
              color: b.isUnlocked ? AppColors.logoGold : foren.textSecondary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          b.title,
          style: TextStyle(
            color: b.isUnlocked ? theme.colorScheme.onSurface : foren.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          b.description,
          style: TextStyle(
            color: foren.textSecondary,
            fontSize: 11,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderRadiusSm,
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '+${b.xpReward} XP',
            style: TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
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

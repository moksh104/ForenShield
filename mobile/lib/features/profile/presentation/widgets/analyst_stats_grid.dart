import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';
import '../pages/profile_screen.dart';

/// Cybersecurity Statistics Dashboard Grid with count-up numeric animations and glassmorphism.
class AnalystStatsGrid extends StatelessWidget {
  final ProfileEntity profile;

  const AnalystStatsGrid({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final stats = profile.stats;
    final unlockedBadges = profile.badges.where((b) => b.isUnlocked).length;

    final statItems = [
      _StatItemData(
        title: 'CASES SOLVED',
        value: stats.casesSolved.toDouble(),
        suffix: '',
        icon: Icons.biotech_outlined,
        color: foren.investigation.t500,
      ),
      _StatItemData(
        title: 'SIMULATIONS',
        value: stats.coursesCompleted.toDouble(),
        suffix: '',
        icon: Icons.alt_route_outlined,
        color: foren.simulation.t500,
      ),
      _StatItemData(
        title: 'STREAK MISSIONS',
        value: stats.currentStreakDays.toDouble(),
        suffix: ' Days',
        icon: Icons.local_fire_department_outlined,
        color: foren.warning.t500,
      ),
      _StatItemData(
        title: 'SECURITY SCORE',
        value: stats.securityScore.toDouble(),
        suffix: '/100',
        icon: Icons.shield_outlined,
        color: foren.success.t500,
      ),
      _StatItemData(
        title: 'INVESTIGATION HRS',
        value: stats.totalLearningHours,
        suffix: ' hrs',
        isDecimal: true,
        icon: Icons.timer_outlined,
        color: AppColors.primary,
      ),
      _StatItemData(
        title: 'BADGES UNLOCKED',
        value: unlockedBadges.toDouble(),
        suffix: '',
        icon: Icons.emoji_events_outlined,
        color: AppColors.logoGold,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.55,
      ),
      itemCount: statItems.length,
      itemBuilder: (context, index) {
        return _StatCard(data: statItems[index]);
      },
    );
  }
}

class _StatItemData {
  final String title;
  final double value;
  final String suffix;
  final bool isDecimal;
  final IconData icon;
  final Color color;

  const _StatItemData({
    required this.title,
    required this.value,
    required this.suffix,
    this.isDecimal = false,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatefulWidget {
  final _StatItemData data;

  const _StatCard({required this.data});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final data = widget.data;

    final Widget cardBody = GlassEffect(
      blurX: 12.0,
      blurY: 12.0,
      opacity: 0.10,
      border: Border.all(
        color: _isHovered ? data.color : foren.borderSubtle,
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusLg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    letterSpacing: 0.6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Icon(data.icon, color: data.color, size: 16),
                ),
              ],
            ),

            // Animated Count-Up Number
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: data.value),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              builder: (context, animatedVal, child) {
                final displayVal = data.isDecimal
                    ? animatedVal.toStringAsFixed(1)
                    : animatedVal.toInt().toString();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      displayVal,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Geist',
                      ),
                    ),
                    if (data.suffix.isNotEmpty)
                      Text(
                        data.suffix,
                        style: TextStyle(
                          color: data.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: ProfileScreen.enableAdvancedEffects
            ? GlowEffect(
                glowColor: _isHovered ? data.color : Colors.transparent,
                blurRadius: 16,
                spreadRadius: 1,
                animate: _isHovered,
                borderRadius: AppRadius.borderRadiusLg,
                child: cardBody,
              )
            : cardBody,
      ),
    );
  }
}

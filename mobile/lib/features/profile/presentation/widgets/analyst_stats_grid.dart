import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';

/// Statistics dashboard grid with count-up numeric animations.
class AnalystStatsGrid extends StatelessWidget {
  final ProfileEntity profile;

  const AnalystStatsGrid({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final stats = profile.stats;
    final unlockedBadges = profile.badges.where((b) => b.isUnlocked).length;

    final statItems = [
      _StatItemData(
        title: 'Cases solved',
        value: stats.casesSolved.toDouble(),
        suffix: '',
        icon: Icons.biotech_outlined,
        color: foren.investigation.t500,
      ),
      _StatItemData(
        title: 'Simulations',
        value: stats.coursesCompleted.toDouble(),
        suffix: '',
        icon: Icons.alt_route_outlined,
        color: foren.simulation.t500,
      ),
      _StatItemData(
        title: 'Streak days',
        value: stats.currentStreakDays.toDouble(),
        suffix: 'd',
        icon: Icons.local_fire_department_outlined,
        color: foren.warning.t500,
      ),
      _StatItemData(
        title: 'Security score',
        value: stats.securityScore.toDouble(),
        suffix: '/100',
        icon: Icons.shield_outlined,
        color: foren.success.t500,
      ),
      _StatItemData(
        title: 'Learning hours',
        value: stats.totalLearningHours,
        suffix: 'h',
        isDecimal: true,
        icon: Icons.timer_outlined,
        color: AppColors.primary,
      ),
      _StatItemData(
        title: 'Badges unlocked',
        value: unlockedBadges.toDouble(),
        suffix: '',
        icon: Icons.emoji_events_outlined,
        color: AppColors.primary,
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        child: GlassEffect(
          border: Border.all(
            color: _isHovered
                ? data.color.withValues(alpha: 0.6)
                : foren.borderSubtle,
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
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foren.textSecondary,
                        fontWeight: FontWeight.w600,
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
                  duration: const Duration(milliseconds: 900),
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
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (data.suffix.isNotEmpty)
                          Text(
                            data.suffix,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: data.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

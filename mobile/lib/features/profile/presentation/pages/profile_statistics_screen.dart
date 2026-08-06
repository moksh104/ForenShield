import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';
import '../providers/profile_provider.dart';

/// User Forensic & Learning Statistics Overview Screen with Glassmorphism & Cyber Analytics.
class ProfileStatisticsScreen extends ConsumerWidget {
  const ProfileStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    final stats =
        ref.watch(profileProvider).profile?.stats ??
        const UserStatsEntity(
          totalLearningHours: 0.0,
          casesSolved: 0,
          coursesCompleted: 0,
          currentStreakDays: 0,
          securityScore: 0,
        );

    final List<_StatTileData> tiles = [
      _StatTileData(
        icon: Icons.timer_outlined,
        label: 'TOTAL INVESTIGATION HOURS',
        value: stats.totalLearningHours,
        suffix: ' hrs',
        isDecimal: true,
        color: primaryColor,
      ),
      _StatTileData(
        icon: Icons.biotech_outlined,
        label: 'CASES SOLVED & RESOLVED',
        value: stats.casesSolved.toDouble(),
        suffix: ' Cases',
        color: foren.investigation.t500,
      ),
      _StatTileData(
        icon: Icons.school_outlined,
        label: 'ACADEMY MODULES COMPLETED',
        value: stats.coursesCompleted.toDouble(),
        suffix: ' Courses',
        color: foren.academy.t500,
      ),
      _StatTileData(
        icon: Icons.local_fire_department_outlined,
        label: 'CURRENT ACTIVE STREAK',
        value: stats.currentStreakDays.toDouble(),
        suffix: ' Days Streak',
        color: foren.warning.t500,
      ),
      _StatTileData(
        icon: Icons.shield_outlined,
        label: 'SECURITY POSTURE SCORE',
        value: stats.securityScore.toDouble(),
        suffix: ' / 100',
        color: foren.success.t500,
      ),
    ];

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
          'Analyst Forensic Statistics',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: List.generate(
                    tiles.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _StatBigTile(data: tiles[index]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTileData {
  final IconData icon;
  final String label;
  final double value;
  final String suffix;
  final bool isDecimal;
  final Color color;

  const _StatTileData({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
    this.isDecimal = false,
    required this.color,
  });
}

class _StatBigTile extends StatefulWidget {
  final _StatTileData data;

  const _StatBigTile({required this.data});

  @override
  State<_StatBigTile> createState() => _StatBigTileState();
}

class _StatBigTileState extends State<_StatBigTile> {
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
        transform: Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
        child: GlassEffect(
          border: Border.all(
            color: _isHovered ? data.color : foren.borderSubtle,
            width: 1.0,
          ),
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Icon(data.icon, color: data.color, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: data.color,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                data.suffix,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: data.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foren.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

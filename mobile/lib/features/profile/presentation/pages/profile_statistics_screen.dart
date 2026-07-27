import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/profile_entity.dart';
import '../providers/profile_provider.dart';

/// User Forensic & Learning Statistics Overview Screen.
class ProfileStatisticsScreen extends ConsumerWidget {
  const ProfileStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final stats = ref.watch(profileProvider).profile?.stats ??
        const UserStatsEntity(
          totalLearningHours: 0.0,
          casesSolved: 0,
          coursesCompleted: 0,
          currentStreakDays: 0,
          securityScore: 0,
        );

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
          'Learning & Forensic Statistics',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _StatBigTile(
                      icon: Icons.timer_outlined,
                      label: 'Total Learning Hours',
                      value: '${stats.totalLearningHours.toStringAsFixed(1)} hrs',
                      color: foren.simulation.t500,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatBigTile(
                      icon: Icons.biotech_outlined,
                      label: 'Cases Solved',
                      value: '${stats.casesSolved} Cases',
                      color: foren.investigation.t500,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatBigTile(
                      icon: Icons.school_outlined,
                      label: 'Courses Completed',
                      value: '${stats.coursesCompleted} Courses',
                      color: foren.academy.t500,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatBigTile(
                      icon: Icons.local_fire_department_outlined,
                      label: 'Current Active Streak',
                      value: '${stats.currentStreakDays} Days Streak',
                      color: foren.warning.t500,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatBigTile(
                      icon: Icons.shield_outlined,
                      label: 'Security Posture Score',
                      value: '${stats.securityScore} / 100',
                      color: foren.success.t500,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StatBigTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBigTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: foren.textDisabled,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

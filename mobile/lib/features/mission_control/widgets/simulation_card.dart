import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// A quick-access banner card for launching the Simulation Lab.
class SimulationCard extends StatelessWidget {
  final String scenarioTitle;
  final String difficultyLabel;
  final Color difficultyColor;
  final String description;
  final VoidCallback? onLaunchTap;

  const SimulationCard({
    super.key,
    this.scenarioTitle = 'Incident Response Drill',
    this.difficultyLabel = 'Medium',
    this.difficultyColor = AppColors.logoBlue,
    this.description =
        'Contain and eradicate an active C2 beacon on a compromised endpoint.',
    this.onLaunchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardRadius,
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A5F), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.logoBlue.withValues(alpha: 0.2)),
        ),
        child: InkWell(
          onTap: onLaunchTap,
          borderRadius: AppRadius.cardRadius,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.logoBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.logoBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.terminal_outlined,
                    color: AppColors.logoBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'SIM LAB',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.logoBlue.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: difficultyColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              difficultyLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: difficultyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        scenarioTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.logoBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.logoBlue,
                    size: 20,
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

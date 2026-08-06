import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Displays the currently active forensic investigation case.
class ActiveInvestigationCard extends StatelessWidget {
  final String caseId;
  final String caseTitle;
  final String caseType;
  final String statusLabel;
  final Color statusColor;
  final String timeActive;
  final int objectivesCompleted;
  final int totalObjectives;
  final VoidCallback? onContinueTap;

  const ActiveInvestigationCard({
    super.key,
    this.caseId = '#FSC-0091',
    this.caseTitle = 'Ransomware Intrusion: NovaCorp',
    this.caseType = 'Ransomware Analysis',
    this.statusLabel = 'In Progress',
    this.statusColor = AppColors.warning,
    this.timeActive = '2h 14m',
    this.objectivesCompleted = 3,
    this.totalObjectives = 7,
    this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalObjectives > 0
        ? objectivesCompleted / totalObjectives
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: statusColor.withValues(alpha: 0.35)),
        ),
        child: InkWell(
          onTap: onContinueTap,
          borderRadius: AppRadius.cardRadius,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            statusLabel.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time_outlined,
                      size: 13,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.45,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeActive,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  caseTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      caseId,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.45,
                        ),
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      caseType,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$objectivesCompleted / $totalObjectives',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'objectives',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerLowest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    FilledButton.tonal(
                      onPressed: onContinueTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: statusColor.withValues(alpha: 0.15),
                        foregroundColor: statusColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

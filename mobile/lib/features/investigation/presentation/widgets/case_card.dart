import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/investigation_entity.dart';

/// Case Card for Investigation Cases list.
class CaseCard extends StatelessWidget {
  final InvestigationEntity caseEntity;
  final VoidCallback? onTap;
  final VoidCallback? onContinueTap;

  const CaseCard({
    super.key,
    required this.caseEntity,
    this.onTap,
    this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final priorityColor = _getPriorityColor(foren, caseEntity.priority);
    final statusColor = _getStatusColor(foren, theme, caseEntity.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: priorityColor.withValues(alpha: 0.35),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag Row
                Row(
                  children: [
                    Text(
                      caseEntity.caseCode,
                      style: TextStyle(
                        color: invColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Text(
                        caseEntity.priority.toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Text(
                        caseEntity.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Case Title
                Text(
                  caseEntity.title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  caseEntity.description,
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                // Progress & CTA
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(caseEntity.progress * 100).toInt()}% Investigated',
                                style: TextStyle(
                                  color: foren.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${caseEntity.evidenceList.length} Evidence Artifacts',
                                style: TextStyle(
                                  color: foren.textDisabled,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: AppRadius.borderRadiusXs,
                            child: LinearProgressIndicator(
                              value: caseEntity.progress,
                              minHeight: 5,
                              backgroundColor: foren.surfaceRaised1,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                priorityColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ElevatedButton(
                      onPressed: onContinueTap ?? onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: invColor,
                        foregroundColor: theme.scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 8,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        caseEntity.progress > 0 ? 'Continue' : 'Investigate',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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

  Color _getPriorityColor(ForenColors foren, String prio) {
    switch (prio.toLowerCase()) {
      case 'critical':
        return foren.critical.t500;
      case 'high':
        return foren.warning.t500;
      case 'medium':
        return foren.simulation.t500;
      case 'low':
      default:
        return foren.textSecondary;
    }
  }

  Color _getStatusColor(ForenColors foren, ThemeData theme, String stat) {
    switch (stat.toLowerCase()) {
      case 'solved':
      case 'completed':
        return foren.success.t500;
      case 'in progress':
        return foren.warning.t500;
      case 'open':
      default:
        return theme.colorScheme.primary;
    }
  }
}

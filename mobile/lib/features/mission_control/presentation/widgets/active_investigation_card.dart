import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Active Investigation Card.
class ActiveInvestigationCard extends StatelessWidget {
  final String caseId;
  final String caseTitle;
  final String caseType;
  final int evidenceCount;
  final String caseStatus;
  final int completedObjectives;
  final int totalObjectives;
  final VoidCallback? onOpenTap;

  const ActiveInvestigationCard({
    super.key,
    required this.caseId,
    required this.caseTitle,
    required this.caseType,
    required this.evidenceCount,
    required this.caseStatus,
    required this.completedObjectives,
    required this.totalObjectives,
    this.onOpenTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final statusColor = _getStatusColor(foren, caseStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: invColor.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: invColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.biotech,
                          size: 12, color: invColor),
                      const SizedBox(width: 4),
                      Text(
                        'ACTIVE INVESTIGATION',
                        style: TextStyle(
                          color: invColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusXs,
                  ),
                  child: Text(
                    caseStatus.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  caseId,
                  style: TextStyle(
                    color: invColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    caseTitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 13,
                  color: foren.textDisabled,
                ),
                const SizedBox(width: 4),
                Text(
                  '$evidenceCount Evidence Artifacts Collected · $caseType',
                  style: TextStyle(
                    color: foren.textDisabled,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Objectives: $completedObjectives / $totalObjectives completed',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onOpenTap,
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
                  icon: const Icon(Icons.arrow_forward, size: 14),
                  label: const Text(
                    'Open Case',
                    style: TextStyle(
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
    );
  }

  Color _getStatusColor(ForenColors foren, String status) {
    switch (status.toUpperCase()) {
      case 'SOLVED':
      case 'COMPLETED':
        return foren.success.t500;
      case 'CRITICAL':
        return foren.critical.t500;
      case 'IN PROGRESS':
      default:
        return foren.warning.t500;
    }
  }
}

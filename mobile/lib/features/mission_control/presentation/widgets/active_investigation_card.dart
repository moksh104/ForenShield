import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Active Investigation Card.
/// Refined: clean surface card, no glass/glow/hover overload.
class ActiveInvestigationCard extends StatefulWidget {
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
  State<ActiveInvestigationCard> createState() =>
      _ActiveInvestigationCardState();
}

class _ActiveInvestigationCardState extends State<ActiveInvestigationCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final statusColor = _getStatusColor(foren, widget.caseStatus);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: invColor.withValues(alpha: 0.3)),
        boxShadow: AppShadows.forBrightness(
          brightness: theme.brightness,
          level: ElevationLevel.low,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: invColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.biotech, size: 12, color: invColor),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'ACTIVE INVESTIGATION',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: invColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.caseStatus.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
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
                widget.caseId,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: invColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  widget.caseTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 13,
                color: foren.textDisabled,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${widget.evidenceCount} Evidence Artifacts Collected · ${widget.caseType}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: foren.textDisabled,
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
                  'Objectives: ${widget.completedObjectives} / ${widget.totalObjectives} completed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foren.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: widget.onOpenTap,
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
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

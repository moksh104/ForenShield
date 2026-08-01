import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Active Investigation Card with glassmorphism, glow effects, and hover interactions.
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final statusColor = _getStatusColor(foren, widget.caseStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          child: GlassEffect(
            blurX: 16.0,
            blurY: 16.0,
            opacity: _isHovered ? 0.16 : 0.12,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? invColor.withValues(alpha: 0.6)
                  : invColor.withValues(alpha: 0.35),
              width: _isHovered ? 1.5 : 1.0,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GlowEffect(
                      glowColor: invColor,
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                      animate: true,
                      borderRadius: AppRadius.borderRadiusXs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: invColor.withValues(alpha: 0.15),
                          borderRadius: AppRadius.borderRadiusXs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.biotech, size: 12, color: invColor),
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
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Text(
                        widget.caseStatus.toUpperCase(),
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
                      widget.caseId,
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
                        widget.caseTitle,
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
                      '${widget.evidenceCount} Evidence Artifacts Collected · ${widget.caseType}',
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
                        'Objectives: ${widget.completedObjectives} / ${widget.totalObjectives} completed',
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GlowEffect(
                      glowColor: invColor,
                      blurRadius: _isHovered ? 12.0 : 6.0,
                      spreadRadius: _isHovered ? 2.0 : 0.0,
                      animate: _isHovered,
                      borderRadius: AppRadius.borderRadiusMd,
                      child: ElevatedButton.icon(
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
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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

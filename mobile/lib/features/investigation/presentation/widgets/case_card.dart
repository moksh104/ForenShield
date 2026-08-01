import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/investigation_entity.dart';
import '../pages/case_list_screen.dart';
import 'threat_level_badge.dart';

/// Glassmorphic Digital Evidence & Investigation Case Card.
class CaseCard extends StatefulWidget {
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
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final primaryColor = theme.colorScheme.primary;

    final caseEntity = widget.caseEntity;
    final priorityColor = _getPriorityColor(foren, caseEntity.priority);
    final statusColor = _getStatusColor(foren, theme, caseEntity.status);
    final progressPercent = (caseEntity.progress * 100).toInt();

    // Risk score calculation based on priority and evidence count
    final riskScore = _calculateRiskScore(caseEntity.priority, caseEntity.evidenceList.length);

    final Widget cardBody = GlassEffect(
      blurX: 12.0,
      blurY: 12.0,
      opacity: 0.10,
      border: Border.all(
        color: _isHovered ? priorityColor : foren.borderSubtle,
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusLg,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: AppRadius.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Tag Row: Case Code, Threat Level Badge & Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.borderRadiusXs,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      caseEntity.caseCode,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  ThreatLevelBadge(priority: caseEntity.priority),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderRadiusXs,
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      caseEntity.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
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
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Geist',
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
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Evidence Artifact Tags & Risk Score Bar
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.logoGold.withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderRadiusSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined, size: 11, color: AppColors.logoGold),
                        const SizedBox(width: 4),
                        Text(
                          'RISK SCORE: $riskScore/100',
                          style: const TextStyle(
                            color: AppColors.logoGold,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${caseEntity.evidenceList.length} ARTIFACTS',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Progress & Action Button Row
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
                              '$progressPercent% INVESTIGATED',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Progress Line
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
                  ElevatedButton.icon(
                    onPressed: widget.onContinueTap ?? widget.onTap,
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
                    icon: Icon(
                      caseEntity.progress > 0 ? Icons.play_arrow : Icons.biotech,
                      size: 14,
                    ),
                    label: Text(
                      caseEntity.progress > 0 ? 'Continue' : 'Investigate',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: CaseListScreen.enableAdvancedEffects
            ? GlowEffect(
                glowColor: _isHovered ? priorityColor : Colors.transparent,
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

  int _calculateRiskScore(String priority, int evidenceCount) {
    int baseScore;
    switch (priority.toLowerCase()) {
      case 'critical':
        baseScore = 85;
        break;
      case 'high':
        baseScore = 70;
        break;
      case 'medium':
        baseScore = 55;
        break;
      case 'low':
      default:
        baseScore = 35;
        break;
    }
    return (baseScore + (evidenceCount * 3)).clamp(0, 99);
  }

  Color _getPriorityColor(ForenColors foren, String prio) {
    switch (prio.toLowerCase()) {
      case 'critical':
        return foren.critical.t500;
      case 'high':
        return foren.warning.t500;
      case 'medium':
        return AppColors.primary;
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
        return AppColors.primary;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../../splash/presentation/widgets/background_grid.dart';
import '../../domain/entities/investigation_entity.dart';
import '../providers/investigation_provider.dart';
import '../widgets/threat_level_badge.dart';

/// Case Details Screen displaying briefing, evidence vault, timeline preview, suspects, and verdict CTA.
class CaseDetailScreen extends ConsumerStatefulWidget {
  final String caseId;

  const CaseDetailScreen({super.key, required this.caseId});

  @override
  ConsumerState<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends ConsumerState<CaseDetailScreen> {
  InvestigationEntity? _caseDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCaseDetail();
  }

  Future<void> _loadCaseDetail() async {
    final repo = ref.read(investigationRepositoryProvider);
    final result = await repo.getCaseDetail(widget.caseId);
    result.when(
      success: (data) {
        if (mounted) {
          setState(() {
            _caseDetail = data;
            _isLoading = false;
          });
        }
      },
      failure: (_) {
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final invColor = foren.investigation.t500;
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: ScannerEffect(
                  color: primaryColor,
                  child: const Center(
                    child: Icon(Icons.folder_special_outlined, size: 48, color: AppColors.logoGold),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'ANALYZING CASE ARTIFACTS...',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final caseDetail = _caseDetail;
    if (caseDetail == null) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        appBar: AppBar(backgroundColor: AppColors.bgBase),
        body: Center(
          child: Text('Case not found.', style: TextStyle(color: foren.textSecondary)),
        ),
      );
    }

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
          caseDetail.caseCode,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 40,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            const Positioned.fill(child: BackgroundGrid()),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Card & Threat Level Badge
                          GlassEffect(
                            blurX: 14.0,
                            blurY: 14.0,
                            opacity: 0.12,
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.35),
                              width: 1.0,
                            ),
                            borderRadius: AppRadius.borderRadiusLg,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ThreatLevelBadge(priority: caseDetail.priority),
                                      Text(
                                        'ASSIGNED: ${caseDetail.assignedDate}',
                                        style: TextStyle(
                                          color: foren.textSecondary,
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    caseDetail.title,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Geist',
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    caseDetail.description,
                                    style: TextStyle(
                                      color: foren.textSecondary,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.1, end: 0),

                          const SizedBox(height: AppSpacing.lg),

                          // Case Objectives Section
                          Text(
                            'INVESTIGATION OBJECTIVES',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              letterSpacing: 1.0,
                            ),
                          )
                              .animate(delay: 100.ms)
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.xs),

                          GlassEffect(
                            blurX: 12.0,
                            blurY: 12.0,
                            opacity: 0.10,
                            border: Border.all(
                              color: foren.borderSubtle,
                              width: 1.0,
                            ),
                            borderRadius: AppRadius.borderRadiusLg,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                children: caseDetail.objectives.map(
                                  (obj) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_box_outlined, size: 16, color: primaryColor),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            obj,
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).toList(),
                              ),
                            ),
                          )
                              .animate(delay: 150.ms)
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.lg),

                          // Evidence Artifacts Vault Preview
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'EVIDENCE ARTIFACT VAULT (${caseDetail.evidenceList.length})',
                                style: TextStyle(
                                  color: foren.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          )
                              .animate(delay: 250.ms)
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.xs),

                          ...caseDetail.evidenceList.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final ev = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                child: GlassEffect(
                                  blurX: 10.0,
                                  blurY: 10.0,
                                  opacity: 0.10,
                                  border: Border.all(
                                    color: foren.borderSubtle,
                                    width: 1.0,
                                  ),
                                  borderRadius: AppRadius.borderRadiusMd,
                                  child: ListTile(
                                    dense: true,
                                    leading: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(alpha: 0.15),
                                        borderRadius: AppRadius.borderRadiusSm,
                                      ),
                                      child: Icon(
                                        _getEvidenceIcon(ev.type),
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    title: Text(
                                      ev.title,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'TYPE: ${ev.type.toUpperCase()} · ${ev.timestamp}',
                                      style: TextStyle(
                                        color: foren.textSecondary,
                                        fontSize: 10,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      context.push('${RouteConstants.evidenceViewer}/${ev.id}');
                                    },
                                  ),
                                )
                                    .animate(delay: Duration(milliseconds: 300 + (index * 60)))
                                    .fadeIn(duration: 400.ms)
                                    .slideX(begin: -0.05, end: 0),
                              );
                            },
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // Attack Chain Timeline Button Link
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.push('${RouteConstants.caseTimeline}/${caseDetail.id}');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: BorderSide(color: primaryColor),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.borderRadiusMd,
                                ),
                              ),
                              icon: const Icon(Icons.timeline, size: 18),
                              label: const Text(
                                'VIEW CHRONOLOGICAL ATTACK TIMELINE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                              .animate(delay: 500.ms)
                              .fadeIn(duration: 400.ms),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Verdict Action Bar
                  GlassEffect(
                    blurX: 14.0,
                    blurY: 14.0,
                    opacity: 0.15,
                    border: Border(top: BorderSide(color: foren.borderSubtle)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.push('${RouteConstants.caseVerdict}/${caseDetail.id}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: invColor,
                            foregroundColor: theme.scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusMd,
                            ),
                          ),
                          icon: const Icon(Icons.gavel, size: 18),
                          label: const Text(
                            'FORMULATE FINAL VERDICT',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEvidenceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'log':
        return Icons.article_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'history':
        return Icons.history_toggle_off;
      case 'image':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

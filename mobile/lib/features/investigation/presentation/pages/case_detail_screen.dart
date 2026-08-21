import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
// import routes
import '../../../../shared/states/empty_state.dart';
import '../../domain/entities/investigation_entity.dart';
import '../providers/investigation_provider.dart';
import '../widgets/threat_level_badge.dart';

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
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }

    final caseDetail = _caseDetail;
    if (caseDetail == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.colorScheme.surface),
        body: const Center(
          child: EmptyState(
            title: 'Case Not Found',
            message: 'The requested investigation case could not be loaded.',
            icon: Icons.error_outline,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Case Identity & Status/Priority
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(color: foren.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThreatLevelBadge(priority: caseDetail.priority),
                        Text(
                          'ASSIGNED: ',
                          style: TextStyle(
                            color: foren.textSecondary,
                            fontSize: 11,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
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

              const SizedBox(height: AppSpacing.lg),

              // Objectives
              Text(
                'OBJECTIVES',
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(color: foren.borderSubtle),
                ),
                child: Column(
                  children: caseDetail.objectives.map((obj) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: primaryColor,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              obj,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Evidence List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EVIDENCE VAULT',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    ' ITEMS',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (caseDetail.evidenceList.isEmpty)
                const EmptyState(
                  title: 'No Evidence Found',
                  message:
                      'There are no artifacts collected for this case yet.',
                  icon: Icons.inventory_2_outlined,
                )
              else
                Column(
                  children: caseDetail.evidenceList.map((ev) {
                    return GestureDetector(
                      onTap: () => context.push('/evidence/'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(color: foren.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ev.title,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Type:  • ',
                                    style: TextStyle(
                                      color: foren.textSecondary,
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: foren.textDisabled,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Timeline Preview
              Text(
                'INVESTIGATION TIMELINE',
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (caseDetail.timeline.isEmpty)
                const EmptyState(
                  title: 'No Timeline Events',
                  message:
                      'The chronological sequence has not been established.',
                  icon: Icons.timeline,
                )
              else
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(color: foren.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      ...caseDetail.timeline.take(3).map((event) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 30,
                                    color: primaryColor.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.timestamp,
                                      style: TextStyle(
                                        color: foren.textSecondary,
                                        fontSize: 10,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    Text(
                                      event.title,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      event.description,
                                      style: TextStyle(
                                        color: foren.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (caseDetail.timeline.length > 3)
                        TextButton(
                          onPressed: () => context.push('/timeline/'),
                          child: const Text('View Full Timeline'),
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Findings / Verdict
              Text(
                'FINDINGS / VERDICT',
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (caseDetail.verdict == null)
                const EmptyState(
                  title: 'No Verdict Reached',
                  message:
                      'Analysis is still ongoing. Complete the objectives to reach a verdict.',
                  icon: Icons.gavel,
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: foren.success.t500.withValues(
                      alpha: isDarkTheme(context) ? 0.05 : 1.0,
                    ),
                    borderRadius: AppRadius.borderRadiusLg,
                    border: Border.all(
                      color: foren.success.t500.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            color: foren.success.t500,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'CONCLUSION REACHED',
                            style: TextStyle(
                              color: foren.success.t500,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        caseDetail.verdict!.explanationText,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool isDarkTheme(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}

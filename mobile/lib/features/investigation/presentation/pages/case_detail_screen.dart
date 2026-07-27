import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../domain/entities/investigation_entity.dart';
import '../providers/investigation_provider.dart';

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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: invColor),
        ),
      );
    }

    final caseDetail = _caseDetail;
    if (caseDetail == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.scaffoldBackgroundColor),
        body: Center(
          child: Text('Case not found.', style: TextStyle(color: foren.textDisabled)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          caseDetail.caseCode,
          style: TextStyle(
            color: invColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Status
                    Text(
                      caseDetail.title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assigned Date: ${caseDetail.assignedDate} · Priority: ${caseDetail.priority}',
                      style: TextStyle(color: foren.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Description
                    Text(
                      caseDetail.description,
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Objectives Checklist
                    Text(
                      'Case Objectives',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ...caseDetail.objectives.map(
                      (obj) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(Icons.check_box_outlined,
                                size: 16, color: invColor),
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
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Evidence Artifacts Vault Preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Evidence Vault (${caseDetail.evidenceList.length})',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ...caseDetail.evidenceList.map(
                      (ev) => Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: foren.borderSubtle.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            _getEvidenceIcon(ev.type),
                            color: invColor,
                            size: 20,
                          ),
                          title: Text(
                            ev.title,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Type: ${ev.type.toUpperCase()} · ${ev.timestamp}',
                            style: TextStyle(
                              color: foren.textDisabled,
                              fontSize: 10,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: foren.textDisabled,
                            size: 18,
                          ),
                          onTap: () {
                            context.push('${RouteConstants.evidenceViewer}/${ev.id}');
                          },
                        ),
                      ),
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
                          'View Chronological Attack Timeline',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Verdict Action Bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: foren.borderSubtle)),
              ),
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
                    'Formulate Final Verdict',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
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

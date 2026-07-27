import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/evidence_entity.dart';
import '../providers/investigation_provider.dart';

/// Evidence Viewer Screen supporting image zoom, log analysis, header preview, and review toggle.
class EvidenceViewerScreen extends ConsumerStatefulWidget {
  final String evidenceId;

  const EvidenceViewerScreen({super.key, required this.evidenceId});

  @override
  ConsumerState<EvidenceViewerScreen> createState() =>
      _EvidenceViewerScreenState();
}

class _EvidenceViewerScreenState extends ConsumerState<EvidenceViewerScreen> {
  EvidenceEntity? _evidence;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvidence();
  }

  Future<void> _loadEvidence() async {
    final useCase = ref.read(loadEvidenceUseCaseProvider);
    final result = await useCase(widget.evidenceId);
    result.when(
      success: (data) {
        if (mounted) {
          setState(() {
            _evidence = data;
            _isLoading = false;
          });
        }
      },
      failure: (_) {
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _markReviewed() async {
    final ev = _evidence;
    if (ev == null) return;
    final foren = Theme.of(context).extension<ForenColors>()!;
    final repo = ref.read(investigationRepositoryProvider);
    final result = await repo.markEvidenceReviewed(ev.id);

    if (!mounted) return;
    result.when(
      success: (updated) {
        setState(() => _evidence = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Evidence marked as reviewed!'),
            backgroundColor: foren.success.t500,
          ),
        );
      },
      failure: (_) {},
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

    final ev = _evidence;
    if (ev == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.scaffoldBackgroundColor),
        body: Center(
          child: Text(
            'Evidence artifact not found.',
            style: TextStyle(color: foren.textDisabled),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          ev.title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
                    // Type & Timestamp Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: invColor.withValues(alpha: 0.15),
                            borderRadius: AppRadius.borderRadiusXs,
                          ),
                          child: Text(
                            ev.type.toUpperCase(),
                            style: TextStyle(
                              color: invColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          ev.timestamp,
                          style: TextStyle(
                            color: foren.textDisabled,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Interactive Content Viewer
                    if (ev.type == 'image') ...[
                      Text(
                        'Interactive Image Viewer (Pinch to Zoom)',
                        style: TextStyle(
                          color: foren.textDisabled,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        height: 220,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F172A),
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                        child: ClipRRect(
                          borderRadius: AppRadius.borderRadiusMd,
                          child: InteractiveViewer(
                            panEnabled: true,
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Center(
                              child: Icon(
                                Icons.image_search,
                                size: 80,
                                color: invColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Raw Payload / Content Box
                    Text(
                      'Evidence Content Payload',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: AppRadius.borderRadiusMd,
                        border: Border.all(
                          color: foren.borderSubtle.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        ev.contentText,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 12,
                          fontFamily: 'monospace',
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Metadata Table
                    if (ev.metadataMap.isNotEmpty) ...[
                      Text(
                        'Extracted Artifact Metadata',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: foren.borderSubtle.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: ev.metadataMap.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: foren.textDisabled,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Action Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: foren.borderSubtle)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: ev.isReviewed ? null : _markReviewed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: invColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(
                    ev.isReviewed ? 'Reviewed ✓' : 'Mark as Reviewed',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

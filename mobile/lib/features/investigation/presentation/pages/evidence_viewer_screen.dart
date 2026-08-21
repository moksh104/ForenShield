import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/evidence_entity.dart';
import '../providers/investigation_provider.dart';
import '../../providers/virus_total_provider.dart';

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
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }

    final ev = _evidence;
    if (ev == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.colorScheme.surface),
        body: Center(
          child: Text(
            'Evidence artifact not found.',
            style: TextStyle(color: foren.textSecondary),
          ),
        ),
      );
    }

    String? vtIndicator;
    final keysToSearch = [
      'SHA-256',
      'SHA-1',
      'MD5',
      'IP Address',
      'URL',
      'Domain',
      'Hash',
      'IP',
    ];
    for (final key in keysToSearch) {
      if (ev.metadataMap.containsKey(key)) {
        vtIndicator = ev.metadataMap[key];
        break;
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          ev.title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRACTICE EVIDENCE Section
              Text(
                'PRACTICE EVIDENCE',
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
                width: double.infinity,
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: AppRadius.borderRadiusXs,
                          ),
                          child: Text(
                            'TYPE: ',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          ev.timestamp,
                          style: TextStyle(
                            color: foren.textSecondary,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Metadata Map
                    ...ev.metadataMap.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toUpperCase(),
                              style: TextStyle(
                                color: foren.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            SelectableText(
                              entry.value,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (ev.contentText.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'EVIDENCE CONTENT',
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
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(color: foren.borderSubtle),
                  ),
                  child: SelectableText(
                    ev.contentText,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 12,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              // EXTERNAL INTELLIGENCE Section (VirusTotal)
              if (vtIndicator != null) ...[
                Text(
                  'EXTERNAL INTELLIGENCE',
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Consumer(
                  builder: (context, ref, child) {
                    final vtAsyncValue = ref.watch(
                      virusTotalProvider(vtIndicator!),
                    );
                    return vtAsyncValue.when(
                      data: (vtModel) {
                        return Container(
                          width: double.infinity,
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
                                children: [
                                  Icon(
                                    Icons.radar_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'VirusTotal Analysis',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ...vtModel.toMap().entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          entry.key,
                                          style: TextStyle(
                                            color: foren.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SelectableText(
                                          entry.value,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 13,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                      error: (error, stack) {
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: AppRadius.borderRadiusLg,
                            border: Border.all(
                              color: theme.colorScheme.error.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            'Live VirusTotal analysis is currently unavailable.',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Review Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: ev.isReviewed ? null : _markReviewed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ev.isReviewed
                        ? theme.colorScheme.surface
                        : primaryColor,
                    foregroundColor: ev.isReviewed
                        ? foren.success.t500
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                      side: ev.isReviewed
                          ? BorderSide(color: foren.success.t500)
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        ev.isReviewed
                            ? Icons.check_circle
                            : Icons.fact_check_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ev.isReviewed ? 'REVIEWED' : 'MARK AS REVIEWED',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

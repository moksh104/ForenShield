import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
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
        backgroundColor: AppColors.bgBase,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Loading evidence…',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foren.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final ev = _evidence;
    if (ev == null) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        appBar: AppBar(backgroundColor: AppColors.bgBase),
        body: Center(
          child: Text(
            'Evidence artifact not found.',
            style: TextStyle(color: foren.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase.withValues(alpha: 0.8),
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
            fontFamily: 'Geist',
          ),
        ),
      ),
      body: ParticleBackground(
        numberOfParticles: 40,
        particleColor: AppColors.logoGold,
        duration: const Duration(seconds: 18),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type & Timestamp Header Badge Row
                          GlassEffect(
                                blurX: 12.0,
                                blurY: 12.0,
                                opacity: 0.12,
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.35),
                                  width: 1.0,
                                ),
                                borderRadius: AppRadius.borderRadiusLg,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(
                                            alpha: 0.15,
                                          ),
                                          borderRadius:
                                              AppRadius.borderRadiusXs,
                                          border: Border.all(
                                            color: primaryColor.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'TYPE: ${ev.type.toUpperCase()}',
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
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.1, end: 0),

                          const SizedBox(height: AppSpacing.md),

                          // Interactive Image Viewer Container
                          if (ev.type == 'image') ...[
                            Text(
                              'INTERACTIVE IMAGE INSPECTOR (PINCH TO ZOOM)',
                              style: TextStyle(
                                color: foren.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 0.8,
                              ),
                            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: AppSpacing.xs),

                            GlassEffect(
                              blurX: 14.0,
                              blurY: 14.0,
                              opacity: 0.12,
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.4),
                                width: 1.0,
                              ),
                              borderRadius: AppRadius.borderRadiusMd,
                              child: SizedBox(
                                height: 220,
                                child: ClipRRect(
                                  borderRadius: AppRadius.borderRadiusMd,
                                  child: InteractiveViewer(
                                    panEnabled: true,
                                    minScale: 0.5,
                                    maxScale: 4.0,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_search,
                                            size: 72,
                                            color: primaryColor.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.sm),
                                          Text(
                                            'PINCH TO ZOOM EVIDENCE ARTIFACT',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: AppSpacing.md),
                          ],

                          // Raw Payload / Content Box
                          Text(
                            'EVIDENCE CONTENT PAYLOAD',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              letterSpacing: 0.8,
                            ),
                          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.xs),

                          GlassEffect(
                            blurX: 14.0,
                            blurY: 14.0,
                            opacity: 0.12,
                            border: Border.all(
                              color: foren.borderSubtle.withValues(alpha: 0.4),
                              width: 1.0,
                            ),
                            borderRadius: AppRadius.borderRadiusMd,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
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
                          ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.lg),

                          // Metadata Table
                          if (ev.metadataMap.isNotEmpty) ...[
                            Text(
                              'EXTRACTED ARTIFACT METADATA',
                              style: TextStyle(
                                color: foren.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 0.8,
                              ),
                            ).animate(delay: 350.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: AppSpacing.xs),

                            GlassEffect(
                              blurX: 14.0,
                              blurY: 14.0,
                              opacity: 0.12,
                              border: Border.all(
                                color: foren.borderSubtle.withValues(
                                  alpha: 0.4,
                                ),
                                width: 1.0,
                              ),
                              borderRadius: AppRadius.borderRadiusMd,
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
                                          entry.key.toUpperCase(),
                                          style: TextStyle(
                                            color: foren.textSecondary,
                                            fontSize: 11,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          entry.value,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Footer
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
                          onPressed: ev.isReviewed ? null : _markReviewed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: invColor,
                            foregroundColor: theme.scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusMd,
                            ),
                          ),
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: Text(
                            ev.isReviewed
                                ? 'ARTIFACT REVIEWED ✓'
                                : 'MARK ARTIFACT AS REVIEWED',
                            style: const TextStyle(
                              fontSize: 13,
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
}

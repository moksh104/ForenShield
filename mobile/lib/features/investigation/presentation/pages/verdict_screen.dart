import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/particle_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/investigation_entity.dart';
import '../providers/investigation_provider.dart';

/// Verdict Formulation Screen displaying evidence summary, final verdict MCQ, score, feedback & XP reward.
class VerdictScreen extends ConsumerStatefulWidget {
  final String caseId;

  const VerdictScreen({super.key, required this.caseId});

  @override
  ConsumerState<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends ConsumerState<VerdictScreen> {
  InvestigationEntity? _caseDetail;
  bool _isLoading = true;
  int? _selectedIndex;
  bool _isSubmitted = false;
  int _scorePercent = 0;

  @override
  void initState() {
    super.initState();
    _loadCase();
  }

  Future<void> _loadCase() async {
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

  Future<void> _submitVerdict() async {
    final c = _caseDetail;
    final idx = _selectedIndex;
    if (c == null || idx == null) return;

    final submitUseCase = ref.read(submitVerdictUseCaseProvider);
    final result = await submitUseCase(caseId: c.id, selectedVerdictIndex: idx);

    result.when(
      success: (score) {
        if (mounted) {
          setState(() {
            _scorePercent = score;
            _isSubmitted = true;
          });
        }
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
                'Preparing verdict…',
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

    final caseDetail = _caseDetail;
    final verdict = caseDetail?.verdict;

    if (caseDetail == null || verdict == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.colorScheme.surface),
        body: Center(
          child: Text(
            'Verdict formulation unavailable.',
            style: TextStyle(color: foren.textSecondary),
          ),
        ),
      );
    }

    if (_isSubmitted) {
      final isCorrect = _selectedIndex == verdict.correctOptionIndex;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: ParticleBackground(
          numberOfParticles: 40,
          particleColor: AppColors.logoGold,
          duration: const Duration(seconds: 18),
          child: Stack(
            children: [
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: GlassEffect(
                      blurX: 16.0,
                      blurY: 16.0,
                      opacity: 0.12,
                      border: Border.all(
                        color: isCorrect
                            ? foren.success.t500
                            : foren.critical.t500,
                        width: 1.0,
                      ),
                      borderRadius: AppRadius.borderRadiusXl,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GlowEffect(
                              glowColor: isCorrect
                                  ? foren.success.t500
                                  : foren.critical.t500,
                              blurRadius: 24,
                              animate: true,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      (isCorrect
                                              ? foren.success.t500
                                              : foren.critical.t500)
                                          .withValues(alpha: 0.15),
                                ),
                                child: Icon(
                                  isCorrect
                                      ? Icons.verified
                                      : Icons.cancel_outlined,
                                  color: isCorrect
                                      ? foren.success.t500
                                      : foren.critical.t500,
                                  size: 54,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              isCorrect
                                  ? 'CASE SOLVED SUCCESSFULLY'
                                  : 'VERDICT INCORRECT',
                              style: TextStyle(
                                color: isCorrect
                                    ? foren.success.t500
                                    : foren.critical.t500,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Score Count-Up
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: _scorePercent.toDouble(),
                              ),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutCubic,
                              builder: (context, animatedVal, child) {
                                return Text(
                                  isCorrect
                                      ? 'ACCURACY: ${animatedVal.toInt()}% · REWARD: +${verdict.xpReward} XP'
                                      : 'SCORE: ${animatedVal.toInt()}% · REVIEW EVIDENCE ARTIFACTS',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: foren.surfaceRaised1.withValues(
                                  alpha: 0.6,
                                ),
                                borderRadius: AppRadius.borderRadiusMd,
                                border: Border.all(
                                  color: foren.borderSubtle.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                verdict.explanationText,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            ElevatedButton(
                              onPressed: () => context.pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: invColor,
                                foregroundColor: theme.scaffoldBackgroundColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.borderRadiusMd,
                                ),
                              ),
                              child: const Text(
                                'RETURN TO LABORATORY',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Formulate Final Case Verdict',
          style: TextStyle(
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
                          // Summary Banner Card
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
                                  child: Text(
                                    verdict.summaryText,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.1, end: 0),

                          const SizedBox(height: AppSpacing.lg),

                          Text(
                            'SELECT ROOT CAUSE / ATTACK VECTOR VERDICT:',
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              letterSpacing: 0.8,
                            ),
                          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                          const SizedBox(height: AppSpacing.sm),

                          // Options List
                          ...List.generate(verdict.options.length, (idx) {
                            final isSelected = _selectedIndex == idx;
                            return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => _selectedIndex = idx);
                                    },
                                    borderRadius: AppRadius.borderRadiusMd,
                                    child: GlassEffect(
                                      blurX: 10.0,
                                      blurY: 10.0,
                                      opacity: isSelected ? 0.20 : 0.10,
                                      border: Border.all(
                                        color: isSelected
                                            ? invColor
                                            : foren.borderSubtle,
                                        width: 1.0,
                                      ),
                                      borderRadius: AppRadius.borderRadiusMd,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          AppSpacing.md,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off,
                                              color: isSelected
                                                  ? invColor
                                                  : foren.textSecondary,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.sm,
                                            ),
                                            Expanded(
                                              child: Text(
                                                verdict.options[idx],
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? invColor
                                                      : theme
                                                            .colorScheme
                                                            .onSurface,
                                                  fontSize: 13,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w800
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .animate(
                                  delay: Duration(
                                    milliseconds: 150 + (idx * 80),
                                  ),
                                )
                                .fadeIn(duration: 400.ms)
                                .slideX(begin: -0.05, end: 0);
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Submit Verdict Footer
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
                          onPressed: _selectedIndex == null
                              ? null
                              : _submitVerdict,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: invColor,
                            foregroundColor: theme.scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusMd,
                            ),
                          ),
                          icon: const Icon(Icons.gavel, size: 18),
                          label: const Text(
                            'SUBMIT VERDICT FOR ANALYSIS',
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
}

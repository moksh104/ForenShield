import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final result = await submitUseCase(
      caseId: c.id,
      selectedVerdictIndex: idx,
    );

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

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: invColor),
        ),
      );
    }

    final caseDetail = _caseDetail;
    final verdict = caseDetail?.verdict;

    if (caseDetail == null || verdict == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.scaffoldBackgroundColor),
        body: Center(
          child: Text(
            'Verdict formulation unavailable.',
            style: TextStyle(color: foren.textDisabled),
          ),
        ),
      );
    }

    if (_isSubmitted) {
      final isCorrect = _selectedIndex == verdict.correctOptionIndex;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCorrect ? Icons.verified : Icons.cancel_outlined,
                    color: isCorrect ? foren.success.t500 : foren.critical.t500,
                    size: 64,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    isCorrect ? 'Case Solved Successfully!' : 'Verdict Incorrect',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isCorrect
                        ? 'Accuracy: $_scorePercent% · Reward: +${verdict.xpReward} XP'
                        : 'Score: $_scorePercent% · Review evidence artifacts',
                    style: TextStyle(
                      color: foren.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadius.borderRadiusMd,
                      border: Border.all(
                        color: foren.borderSubtle.withValues(alpha: 0.3),
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
                    ),
                    child: const Text('Return to Laboratory'),
                  ),
                ],
              ),
            ),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
                    // Summary Banner
                    Text(
                      verdict.summaryText,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Select Root Cause / Attack Vector Verdict:',
                      style: TextStyle(
                        color: foren.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Options List
                    ...List.generate(verdict.options.length, (idx) {
                      final isSelected = _selectedIndex == idx;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedIndex = idx);
                          },
                          borderRadius: AppRadius.borderRadiusMd,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? invColor.withValues(alpha: 0.15)
                                  : theme.colorScheme.surface,
                              borderRadius: AppRadius.borderRadiusMd,
                              border: Border.all(
                                color: isSelected
                                    ? invColor
                                    : foren.borderSubtle.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              verdict.options[idx],
                              style: TextStyle(
                                color: isSelected
                                    ? invColor
                                    : theme.colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Submit Verdict Footer
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
                  onPressed: _selectedIndex == null ? null : _submitVerdict,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: invColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  icon: const Icon(Icons.gavel, size: 18),
                  label: const Text(
                    'Submit Verdict',
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
}

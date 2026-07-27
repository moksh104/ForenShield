import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/quiz_entity.dart';
import '../providers/course_provider.dart';

/// Quiz Screen supporting MCQs, immediate feedback, score calculation, pass/fail result, and retry.
class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  QuizEntity? _quiz;
  bool _isLoading = true;
  int _currentIndex = 0;
  final Map<String, int> _selectedAnswers = {};
  bool _isSubmitted = false;
  int _scorePercent = 0;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final repo = ref.read(courseRepositoryProvider);
    final result = await repo.getQuiz(widget.quizId);
    result.when(
      success: (quiz) {
        if (mounted) {
          setState(() {
            _quiz = quiz;
            _isLoading = false;
          });
        }
      },
      failure: (_) {
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _submitQuiz() async {
    final quiz = _quiz;
    if (quiz == null) return;
    final submitUseCase = ref.read(submitQuizUseCaseProvider);
    final result = await submitUseCase(
      quizId: quiz.id,
      selectedOptions: _selectedAnswers,
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

  void _retryQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswers.clear();
      _isSubmitted = false;
      _scorePercent = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator(color: academyColor)),
      );
    }

    final quiz = _quiz;
    if (quiz == null || quiz.questions.isEmpty) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.scaffoldBackgroundColor),
        body: Center(
          child: Text('Quiz not available.', style: TextStyle(color: foren.textDisabled)),
        ),
      );
    }

    if (_isSubmitted) {
      final isPassed = _scorePercent >= quiz.passingScorePercent;

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
                    isPassed ? Icons.emoji_events : Icons.cancel_outlined,
                    color: isPassed ? foren.success.t500 : foren.critical.t500,
                    size: 64,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    isPassed ? 'Quiz Passed!' : 'Quiz Failed',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Your Score: $_scorePercent% (Passing: ${quiz.passingScorePercent}%)',
                    style: TextStyle(color: foren.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: _retryQuiz,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                        ),
                        child: const Text('Retry Quiz'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: academyColor,
                          foregroundColor: theme.scaffoldBackgroundColor,
                        ),
                        child: const Text('Done'),
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

    final question = quiz.questions[_currentIndex];
    final selectedIndex = _selectedAnswers[question.id];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Question ${_currentIndex + 1} of ${quiz.questions.length}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / quiz.questions.length,
                backgroundColor: foren.surfaceRaised1,
                valueColor: AlwaysStoppedAnimation<Color>(academyColor),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                question.questionText,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, idx) {
                    final isSelected = selectedIndex == idx;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAnswers[question.id] = idx;
                        });
                      },
                      borderRadius: AppRadius.borderRadiusMd,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? academyColor.withValues(alpha: 0.15)
                              : theme.colorScheme.surface,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: isSelected
                                ? academyColor
                                : foren.borderSubtle.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          question.options[idx],
                          style: TextStyle(
                            color: isSelected
                                ? academyColor
                                : theme.colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () {
                          if (_currentIndex < quiz.questions.length - 1) {
                            setState(() => _currentIndex++);
                          } else {
                            _submitQuiz();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: academyColor,
                    foregroundColor: theme.scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  child: Text(
                    _currentIndex < quiz.questions.length - 1
                        ? 'Next Question'
                        : 'Submit Quiz',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../routes/route_constants.dart';
import '../../domain/entities/lesson_entity.dart';
import '../providers/course_provider.dart';

/// Lesson Player Screen with interactive checklist, code snippet viewer, and complete CTA.
class LessonPlayerScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonPlayerScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  LessonEntity? _lesson;
  bool _isLoading = true;
  bool _isMarking = false;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final useCase = ref.read(loadLessonUseCaseProvider);
    final result = await useCase(widget.lessonId);
    result.when(
      success: (lesson) {
        if (mounted) {
          setState(() {
            _lesson = lesson;
            _isLoading = false;
          });
        }
      },
      failure: (_) {
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _toggleChecklist(int index) async {
    final lesson = _lesson;
    if (lesson == null) return;
    final updatedChecklist = List<LessonChecklistItemEntity>.from(lesson.checklist);
    final current = updatedChecklist[index];
    updatedChecklist[index] = current.copyWith(isChecked: !current.isChecked);

    setState(() {
      _lesson = lesson.copyWith(checklist: updatedChecklist);
    });
  }

  Future<void> _markComplete() async {
    final lesson = _lesson;
    if (lesson == null) return;
    setState(() => _isMarking = true);

    final repo = ref.read(courseRepositoryProvider);
    final result = await repo.markLessonCompleted(lesson.id);

    if (!mounted) return;
    setState(() => _isMarking = false);

    final foren = Theme.of(context).extension<ForenColors>()!;

    result.when(
      success: (updated) {
        setState(() => _lesson = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lesson Marked Complete! +50 XP'),
            backgroundColor: foren.success.t500,
          ),
        );
      },
      failure: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: foren.critical.t500),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator(color: academyColor)),
      );
    }

    final lesson = _lesson;
    if (lesson == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: theme.scaffoldBackgroundColor),
        body: Center(
          child: Text('Lesson not found.', style: TextStyle(color: foren.textDisabled)),
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
          lesson.title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
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
                    // Text Content
                    Text(
                      lesson.contentText,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Code Snippet Block
                    if (lesson.codeSnippet != null) ...[
                      Text(
                        'Command / Code Example',
                        style: TextStyle(
                          color: foren.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _CodeSnippetCard(
                        code: lesson.codeSnippet!,
                        language: lesson.codeLanguage ?? 'bash',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Practical Checklist Section
                    if (lesson.checklist.isNotEmpty) ...[
                      Text(
                        'Practical Checklist',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...List.generate(lesson.checklist.length, (i) {
                        final item = lesson.checklist[i];
                        return CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: item.isChecked
                                  ? foren.textDisabled
                                  : theme.colorScheme.onSurface,
                              fontSize: 13,
                              decoration: item.isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          value: item.isChecked,
                          activeColor: foren.success.t500,
                          checkColor: theme.scaffoldBackgroundColor,
                          onChanged: (_) => _toggleChecklist(i),
                        );
                      }),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ],
                ),
              ),
            ),

            // Navigation & Action Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: foren.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: lesson.isCompleted || _isMarking
                          ? null
                          : _markComplete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: foren.success.t500,
                        side: BorderSide(color: foren.success.t500),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                      ),
                      child: Text(
                        lesson.isCompleted ? 'Completed ✓' : 'Mark Complete',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  if (lesson.quizId != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('${RouteConstants.quizScreen}/${lesson.quizId}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: academyColor,
                        foregroundColor: theme.scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                        ),
                      ),
                      icon: const Icon(Icons.quiz_outlined, size: 16),
                      label: const Text('Take Quiz', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeSnippetCard extends StatelessWidget {
  final String code;
  final String language;

  const _CodeSnippetCard({required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard!')),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 12, color: foren.textDisabled),
                    const SizedBox(width: 4),
                    Text('Copy', style: TextStyle(color: foren.textDisabled, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            code,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 12,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

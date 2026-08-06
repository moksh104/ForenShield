import 'package:flutter/material.dart';

import '../widgets/lesson_header.dart';
import '../widgets/lesson_markdown.dart';
import '../widgets/code_block.dart';
import '../widgets/warning_box.dart';
import '../widgets/cyber_tip.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/nav_controls.dart';
import '../widgets/progress_bar.dart';
import '../widgets/mark_complete_button.dart';
import '../../models/lesson_model.dart';
import '../../models/lesson_content_models.dart';

/// Lesson Player Page - UI only
///
/// - Renders markdown content (images, code blocks)
/// - Shows warning boxes, cyber tips, quiz widgets
/// - Provides previous/next and mark complete CTA
class LessonPlayerPage extends StatelessWidget {
  final LessonModel lesson;
  final LessonContent content;
  final List<QuizQuestion> quizQuestions;
  final double progress; // 0..1
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onComplete;

  const LessonPlayerPage({Key? key, required this.lesson, required this.content, this.quizQuestions = const <QuizQuestion>[], this.progress = 0.0, this.onPrev, this.onNext, this.onComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: LessonHeader(lesson: lesson, progress: progress, onBack: () => Navigator.of(context).pop())),
          SliverToBoxAdapter(child: LessonProgressBar(progress: progress, label: 'Lesson progress')),
          SliverToBoxAdapter(child: LessonMarkdown(markdown: content.markdown)),

          // Example of static warning and tips rendered within content flow
          SliverToBoxAdapter(child: WarningBox(title: 'Important', message: 'Always use isolated lab environments for hands-on exercises.')),
          SliverToBoxAdapter(child: CyberTip(title: 'Tip', body: 'Use packet captures to analyze suspicious traffic.')),

          // Render code block example (UI-only; in real use this would be parsed from markdown)
          SliverToBoxAdapter(child: CodeBlock(code: """# Example bash
sudo tcpdump -i eth0 -w capture.pcap
""")),

          // Quiz section
          if (quizQuestions.isNotEmpty) SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Text('Quiz', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)))),
          ...quizQuestions.map((q) => SliverToBoxAdapter(child: QuizWidget(question: q))).toList(),

          SliverToBoxAdapter(child: const SizedBox(height: 96)),
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: NavControls(onPrevious: onPrev, onNext: onNext)),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Expanded(child: MarkCompleteButton(onPressed: onComplete)), const SizedBox(width: 12), ElevatedButton(onPressed: () {}, child: const Text('Notes'))])),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

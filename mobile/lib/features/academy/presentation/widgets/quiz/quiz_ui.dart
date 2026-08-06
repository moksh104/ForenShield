import 'dart:async';
import 'package:flutter/material.dart';
import '../../../quiz/quiz_engine.dart';
import '../../../quiz/quiz_models.dart';

/// UI widgets for rendering quizzes. These are purely presentational and call into the [QuizEngine]
/// for logic. The widgets themselves do not perform scoring or business logic.

/// Top-level quiz view that connects to a [QuizEngine].
class QuizView extends StatefulWidget {
  final QuizEngine engine;

  const QuizView({Key? key, required this.engine}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> with SingleTickerProviderStateMixin {
  late QuizState _state;
  late final StreamSubscription<QuizState> _sub;

  // animation controller for completion
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _state = widget.engine.state;
    _sub = widget.engine.onStateChanged.listen((s) {
      setState(() => _state = s);
      if (s.completed) {
        _confettiController.forward(from: 0);
      }
    });
    _confettiController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  }

  @override
  void dispose() {
    _sub.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.engine.currentQuestion;
    final selected = _state.selectedOptions[q.id] ?? <String>[];

    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Text(q.question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
      const SizedBox(height: 8),
      if (q.type == QuestionType.singleChoice) SingleChoiceQuestion(question: q, selectedOptionId: selected.isNotEmpty ? selected.first : null, onSelect: (id) => widget.engine.toggleOption(id), onSubmit: () => widget.engine.submitCurrent()),
      if (q.type == QuestionType.multipleChoice) MultipleChoiceQuestion(question: q, selectedOptionIds: selected, onToggle: (id) => widget.engine.toggleOption(id), onSubmit: () => widget.engine.submitCurrent()),
      if (q.type == QuestionType.trueFalse) TrueFalseQuestion(question: q, selectedOptionId: selected.isNotEmpty ? selected.first : null, onSelect: (id) => widget.engine.toggleOption(id), onSubmit: () => widget.engine.submitCurrent()),
      if (q.type == QuestionType.dragAndDrop) Placeholder(child: Text('Drag & Drop UI coming soon (future-ready)')),

      const SizedBox(height: 12),
      // show explanation if answered
      if (_state.results.containsKey(q.id))
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(_state.results[q.id]!.explanation ?? '', style: Theme.of(context).textTheme.bodyMedium)),

      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: widget.engine.previous, child: const Text('Previous'))),
        const SizedBox(width: 12),
        ElevatedButton(onPressed: widget.engine.next, child: const Text('Next'))
      ]) ,

      // completion animation
      SizeTransition(
        sizeFactor: CurvedAnimation(parent: _confettiController, curve: Curves.elasticOut),
        axisAlignment: -1,
        child: Opacity(
          opacity: _state.completed ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Icon(Icons.celebration, size: 60, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text('Quiz complete! Score: ${_state.score} • XP: ${_state.xp}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      )
    ]);
  }
}

class SingleChoiceQuestion extends StatelessWidget {
  final QuizQuestionModel question;
  final String? selectedOptionId;
  final void Function(String optionId) onSelect;
  final VoidCallback onSubmit;

  const SingleChoiceQuestion({Key? key, required this.question, this.selectedOptionId, required this.onSelect, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: question.options.map((o) => RadioListTile<String>(value: o.id, groupValue: selectedOptionId, onChanged: (v) => onSelect(o.id), title: Text(o.text))).toList(growable: false));
  }
}

class MultipleChoiceQuestion extends StatelessWidget {
  final QuizQuestionModel question;
  final List<String> selectedOptionIds;
  final void Function(String optionId) onToggle;
  final VoidCallback onSubmit;

  const MultipleChoiceQuestion({Key? key, required this.question, this.selectedOptionIds = const <String>[], required this.onToggle, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...question.options.map((o) {
        final selected = selectedOptionIds.contains(o.id);
        return CheckboxListTile(value: selected, onChanged: (_) => onToggle(o.id), title: Text(o.text));
      }).toList(),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: ElevatedButton(onPressed: onSubmit, child: const Text('Submit')))
    ]);
  }
}

class TrueFalseQuestion extends StatelessWidget {
  final QuizQuestionModel question;
  final String? selectedOptionId;
  final void Function(String optionId) onSelect;
  final VoidCallback onSubmit;

  const TrueFalseQuestion({Key? key, required this.question, this.selectedOptionId, required this.onSelect, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assume options contain two options with ids 'true' and 'false' or similar
    return Column(children: [
      ...question.options.map((o) => RadioListTile<String>(value: o.id, groupValue: selectedOptionId, onChanged: (v) => onSelect(o.id), title: Text(o.text))).toList(),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: ElevatedButton(onPressed: onSubmit, child: const Text('Submit')))
    ]);
  }
}

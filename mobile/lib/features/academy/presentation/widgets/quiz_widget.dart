import 'package:flutter/material.dart';
import '../../models/lesson_content_models.dart';

/// Stateless quiz widget that renders a single-choice question.
///
/// - Accepts QuizQuestion and a callback when an option is tapped.
class QuizWidget extends StatelessWidget {
  final QuizQuestion question;
  final void Function(String optionId)? onOptionSelected;

  const QuizWidget({Key? key, required this.question, this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(question.question, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...question.options.map((o) => ListTile(
                  title: Text(o.text),
                  leading: Radio<String>(value: o.id, groupValue: null, onChanged: (v) => onOptionSelected?.call(o.id)),
                  onTap: () => onOptionSelected?.call(o.id),
                )),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A styled code block widget for showing pre-formatted code.
class CodeBlock extends StatelessWidget {
  final String code;
  final String? language;

  const CodeBlock({Key? key, required this.code, this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectableText(code, style: const TextStyle(fontFamily: 'monospace')),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Warning box used in lessons to draw attention to important cautions.
class WarningBox extends StatelessWidget {
  final String title;
  final String message;

  const WarningBox({Key? key, required this.title, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Icon(Icons.warning_amber_rounded, color: cs.error),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(message, style: Theme.of(context).textTheme.bodyMedium)])),
          ]),
        ),
      ),
    );
  }
}

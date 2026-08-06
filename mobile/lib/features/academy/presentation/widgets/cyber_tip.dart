import 'package:flutter/material.dart';

/// Small tip callout styled for cybersecurity advice.
class CyberTip extends StatelessWidget {
  final String title;
  final String body;

  const CyberTip({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: cs.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.security, color: cs.onPrimary, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(body, style: Theme.of(context).textTheme.bodyMedium)])),
          ]),
        ),
      ),
    );
  }
}

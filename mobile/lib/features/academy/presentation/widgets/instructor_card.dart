import 'package:flutter/material.dart';

/// Simple instructor card showing avatar, name and role/affiliation.
class InstructorCard extends StatelessWidget {
  final String name;
  final String role;
  final Widget? avatar;

  const InstructorCard({Key? key, required this.name, required this.role, this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            avatar ?? CircleAvatar(radius: 28, backgroundColor: cs.primaryContainer, child: Icon(Icons.person, color: cs.onPrimaryContainer)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(role, style: Theme.of(context).textTheme.bodySmall)])),
            ElevatedButton(onPressed: () {}, child: const Text('Contact'))
          ]),
        ),
      ),
    );
  }
}

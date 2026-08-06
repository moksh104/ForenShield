import 'package:flutter/material.dart';

/// Modules section showing a vertical list of modules with counts.
///
/// Accepts a list of module titles (and optional lesson counts) and a tap callback.
class ModulesSection extends StatelessWidget {
  final List<Map<String, dynamic>> modules; // {'title': string, 'lessons': int}
  final void Function(int index)? onTap;

  const ModulesSection({Key? key, this.modules = const <Map<String, dynamic>>[], this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Modules', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        ...List.generate(modules.length, (i) {
          final m = modules[i];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(m['title'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            subtitle: Text('${m['lessons'] ?? 0} lessons', style: theme.textTheme.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onTap?.call(i),
          );
        })
      ]),
    );
  }
}

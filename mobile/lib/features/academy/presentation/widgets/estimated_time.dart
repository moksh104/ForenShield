import 'package:flutter/material.dart';

/// Displays an estimated time badge.
class EstimatedTime extends StatelessWidget {
  final Duration duration;

  const EstimatedTime({Key? key, required this.duration}) : super(key: key);

  String get _label {
    final mins = duration.inMinutes;
    if (mins < 60) return '$mins min';
    final hours = duration.inHours;
    final rem = mins - hours * 60;
    return rem == 0 ? '${hours}h' : '${hours}h ${rem}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.schedule, size: 16),
        const SizedBox(width: 8),
        Text(_label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

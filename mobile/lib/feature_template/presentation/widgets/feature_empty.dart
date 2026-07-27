import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_state.dart';

/// The specific empty state view for this Feature.
class FeatureEmpty extends StatelessWidget {
  const FeatureEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      title: 'No Features',
      description: 'No features found at this time.',
      icon: Icons.inbox_outlined,
    );
  }
}

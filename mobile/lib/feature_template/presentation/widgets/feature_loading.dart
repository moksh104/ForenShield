import 'package:flutter/material.dart';
import '../../../core/widgets/app_loading_state.dart';

/// The specific loading skeleton or indicator for this Feature.
class FeatureLoading extends StatelessWidget {
  const FeatureLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLoadingState(
      title: 'Loading',
      description: 'Loading features...',
    );
  }
}

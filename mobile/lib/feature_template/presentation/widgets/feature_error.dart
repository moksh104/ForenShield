import 'package:flutter/material.dart';
import '../../../core/widgets/app_error_state.dart';

/// The specific error view for this Feature.
class FeatureError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const FeatureError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      title: 'Error Loading Features',
      description: message,
      onRetry: onRetry,
    );
  }
}

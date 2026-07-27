import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feature_provider.dart';
import '../providers/feature_state.dart';
import '../widgets/feature_card.dart';
import '../widgets/feature_loading.dart';
import '../widgets/feature_error.dart';
import '../widgets/feature_empty.dart';
import '../../../core/widgets/layouts/app_page.dart';

/// The main entry point page for the Feature.
class FeaturePage extends ConsumerWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);

    return AppPage(
      appBar: AppBar(title: const Text('Feature Template')),
      onRefresh: () => ref.read(featureProvider.notifier).refresh(),
      body: _buildBody(state, ref),
    );
  }

  Widget _buildBody(FeatureState featureState, WidgetRef ref) {
    if (featureState.isLoading && featureState.features.isEmpty) {
      return const FeatureLoading();
    }

    if (featureState.errorMessage != null && featureState.features.isEmpty) {
      return FeatureError(
        message: featureState.errorMessage!,
        onRetry: () => ref.read(featureProvider.notifier).loadFeatures(),
      );
    }

    if (featureState.features.isEmpty) {
      return const FeatureEmpty();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: featureState.features.length,
      itemBuilder: (context, index) {
        final feature = featureState.features[index];
        return FeatureCard(entity: feature);
      },
    );
  }
}

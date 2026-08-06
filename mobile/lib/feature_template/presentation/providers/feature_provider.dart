import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feature_state.dart';
import '../../domain/usecases/get_feature.dart';
import '../../../core/models/failure.dart' as core_fail;

// Note: In a real implementation, you would use Dependency Injection (e.g. get_it or a provider block)
// to inject the UseCases. We leave them uninitialized here for template purposes.

final featureProvider =
    StateNotifierProvider.autoDispose<FeatureNotifier, FeatureState>((ref) {
      throw UnimplementedError('Provide GetFeaturesUseCase via DI');
    });

/// Manages the state of the Feature screen.
class FeatureNotifier extends StateNotifier<FeatureState> {
  final GetFeaturesUseCase getFeaturesUseCase;

  FeatureNotifier(this.getFeaturesUseCase) : super(const FeatureState()) {
    loadFeatures();
  }

  /// Fetches data from the domain layer and maps it to UI state.
  Future<void> loadFeatures() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await getFeaturesUseCase.execute();

    result.when(
      success: (features) {
        state = state.copyWith(isLoading: false, features: features);
      },
      failure: (exception) {
        String msg = exception.toString();
        if (exception is core_fail.Failure) {
          msg = exception.message;
        }
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }

  /// Refreshes the data without showing a blocking loading indicator.
  Future<void> refresh() async {
    final result = await getFeaturesUseCase.execute();
    result.when(
      success: (features) {
        state = state.copyWith(features: features, errorMessage: null);
      },
      failure: (exception) {
        String msg = exception.toString();
        if (exception is core_fail.Failure) {
          msg = exception.message;
        }
        state = state.copyWith(errorMessage: msg);
      },
    );
  }
}

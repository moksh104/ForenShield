import 'package:equatable/equatable.dart';
import '../../domain/entities/feature_entity.dart';

/// Represents the state of the Feature screen.
class FeatureState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<FeatureEntity> features;

  const FeatureState({
    this.isLoading = false,
    this.errorMessage,
    this.features = const [],
  });

  FeatureState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<FeatureEntity>? features,
  }) {
    return FeatureState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      features: features ?? this.features,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, features];
}

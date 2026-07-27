import 'package:equatable/equatable.dart';

/// The core Domain Entity for the feature.
/// This class must remain entirely independent of external frameworks (JSON, APIs, Flutter).
/// It represents the raw business logic rules and state.
class FeatureEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  const FeatureEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  /// Example of domain logic: Is this feature considered new?
  bool get isNew => DateTime.now().difference(createdAt).inDays < 7;

  @override
  List<Object?> get props => [id, name, description, createdAt];
}

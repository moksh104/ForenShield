import '../../domain/entities/feature_entity.dart';

/// The Data Transfer Object (DTO) for the Feature.
/// Extends the domain entity to inherit its properties but adds
/// JSON serialization specifically for the Data Layer.
class FeatureModel extends FeatureEntity {
  const FeatureModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  /// Factory constructor to instantiate from JSON payload.
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// Converts the model to JSON for API or Local Storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Maps an entity to a model.
  factory FeatureModel.fromEntity(FeatureEntity entity) {
    return FeatureModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}

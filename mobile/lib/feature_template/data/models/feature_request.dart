/// Encapsulates the payload sent to the API when creating or updating a feature.
class FeatureRequest {
  final String name;
  final String description;

  const FeatureRequest({required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description};
  }
}

import 'package:equatable/equatable.dart';

/// Immutable category model for course grouping.
///
/// - const constructor
/// - manual fromJson / toJson
/// - copyWith
class CategoryModel extends Equatable {
  /// Unique id for the category
  final String id;

  /// Display name
  final String name;

  /// Optional description
  final String? description;

  const CategoryModel({required this.id, required this.name, this.description});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description};

  CategoryModel copyWith({String? id, String? name, String? description}) {
    return CategoryModel(id: id ?? this.id, name: name ?? this.name, description: description ?? this.description);
  }

  @override
  List<Object?> get props => [id, name, description];
}

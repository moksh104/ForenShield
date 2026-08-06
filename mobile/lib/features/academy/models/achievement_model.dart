import 'package:equatable/equatable.dart';

/// Immutable Achievement model representing earned or in-progress achievements.
///
/// - const constructor
/// - manual fromJson / toJson
/// - copyWith
class AchievementModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double progress; // 0.0 - 1.0

  const AchievementModel({required this.id, required this.name, required this.description, this.progress = 0.0});

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description, 'progress': progress};

  AchievementModel copyWith({String? id, String? name, String? description, double? progress}) {
    return AchievementModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [id, name, description, progress];
}

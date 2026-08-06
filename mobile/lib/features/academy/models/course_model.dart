import 'package:equatable/equatable.dart';

/// Immutable model representing a Course in the Cyber Academy.
///
/// - const constructor
/// - manual fromJson / toJson
/// - copyWith for convenient updates
/// - extends Equatable for value equality
class CourseModel extends Equatable {
  /// Unique identifier for the course
  final String id;

  /// Title shown to users
  final String title;

  /// Short subtitle or description
  final String subtitle;

  /// Optional author or provider name
  final String? author;

  /// Progress as 0.0 - 1.0
  final double progress;

  /// Whether the course is locked/premium
  final bool locked;

  /// Optional tags for filtering or display
  final List<String> tags;

  const CourseModel({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.author,
    this.progress = 0.0,
    this.locked = false,
    this.tags = const <String>[],
  });

  /// Manual JSON factory
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      author: json['author'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      locked: json['locked'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
    );
  }

  /// Manual toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'author': author,
        'progress': progress,
        'locked': locked,
        'tags': tags,
      };

  /// Returns a copy with updated fields.
  CourseModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? author,
    double? progress,
    bool? locked,
    List<String>? tags,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      progress: progress ?? this.progress,
      locked: locked ?? this.locked,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, author, progress, locked, tags];
}

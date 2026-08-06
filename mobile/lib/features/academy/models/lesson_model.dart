import 'package:equatable/equatable.dart';

/// Immutable model representing a Lesson within a course.
///
/// - const constructor
/// - manual fromJson / toJson
/// - copyWith
/// - extends Equatable
class LessonModel extends Equatable {
  /// Unique identifier for the lesson
  final String id;

  /// The course id this lesson belongs to
  final String courseId;

  /// Title of the lesson
  final String title;

  /// Duration in minutes (optional)
  final int? durationMinutes;

  /// Whether user completed the lesson
  final bool completed;

  const LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.durationMinutes,
    this.completed = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      durationMinutes: json['durationMinutes'] as int?,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'durationMinutes': durationMinutes,
        'completed': completed,
      };

  LessonModel copyWith({String? id, String? courseId, String? title, int? durationMinutes, bool? completed}) {
    return LessonModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [id, courseId, title, durationMinutes, completed];
}

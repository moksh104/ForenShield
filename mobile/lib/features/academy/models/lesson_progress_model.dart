/// Tracks a user's progress on a specific lesson.
class LessonProgressModel {
  /// The ID of the lesson this progress entry belongs to.
  final String lessonId;

  /// The ID of the parent module.
  final String moduleId;

  /// The ID of the parent course.
  final String courseId;

  /// Whether the lesson has been marked complete.
  final bool isCompleted;

  /// Scrolled / watched progress as a fraction (0.0 – 1.0).
  final double contentProgress;

  /// The UTC timestamp when the lesson was last accessed.
  final DateTime? lastAccessedAt;

  /// The UTC timestamp when the lesson was completed.
  final DateTime? completedAt;

  const LessonProgressModel({
    required this.lessonId,
    required this.moduleId,
    required this.courseId,
    this.isCompleted = false,
    this.contentProgress = 0.0,
    this.lastAccessedAt,
    this.completedAt,
  });

  /// Creates a [LessonProgressModel] from a JSON map.
  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      lessonId: json['lesson_id'] as String,
      moduleId: json['module_id'] as String,
      courseId: json['course_id'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      contentProgress: (json['content_progress'] as num?)?.toDouble() ?? 0.0,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.tryParse(json['last_accessed_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'module_id': moduleId,
      'course_id': courseId,
      'is_completed': isCompleted,
      'content_progress': contentProgress,
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

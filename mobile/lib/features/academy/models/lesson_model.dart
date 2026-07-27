/// Represents a single lesson within a module.
class LessonModel {
  /// Unique identifier for the lesson.
  final String id;

  /// Display title of the lesson.
  final String title;

  /// Short description of the lesson content.
  final String description;

  /// Estimated duration in minutes.
  final int durationMinutes;

  /// The type of content (e.g. 'video', 'quiz', 'reading', 'lab').
  final String contentType;

  /// The order index of this lesson within its parent module.
  final int order;

  /// Whether the lesson has been completed by the current user.
  final bool isCompleted;

  /// Whether the lesson is locked (requires prior lessons to be completed).
  final bool isLocked;

  /// XP reward on completion.
  final int xpReward;

  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.contentType,
    required this.order,
    this.isCompleted = false,
    this.isLocked = false,
    this.xpReward = 50,
  });

  /// Creates a [LessonModel] from a JSON map returned by the API.
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      contentType: json['content_type'] as String? ?? 'reading',
      order: json['order'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      isLocked: json['is_locked'] as bool? ?? false,
      xpReward: json['xp_reward'] as int? ?? 50,
    );
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration_minutes': durationMinutes,
      'content_type': contentType,
      'order': order,
      'is_completed': isCompleted,
      'is_locked': isLocked,
      'xp_reward': xpReward,
    };
  }

  /// Returns a copy of this model with updated fields.
  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    int? durationMinutes,
    String? contentType,
    int? order,
    bool? isCompleted,
    bool? isLocked,
    int? xpReward,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      contentType: contentType ?? this.contentType,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      xpReward: xpReward ?? this.xpReward,
    );
  }
}

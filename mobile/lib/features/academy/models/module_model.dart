import 'lesson_model.dart';

/// Represents a module — a themed group of lessons within a course.
class ModuleModel {
  /// Unique identifier for the module.
  final String id;

  /// Display title.
  final String title;

  /// Short description of what is covered.
  final String description;

  /// Ordered list of lessons in this module.
  final List<LessonModel> lessons;

  /// The order index of this module within its parent course.
  final int order;

  /// Whether the entire module has been completed.
  final bool isCompleted;

  /// The number of completed lessons.
  final int completedLessons;

  const ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.order,
    this.isCompleted = false,
    this.completedLessons = 0,
  });

  /// Total number of lessons in this module.
  int get totalLessons => lessons.length;

  /// Progress value between 0.0 and 1.0.
  double get progress =>
      totalLessons > 0 ? completedLessons / totalLessons : 0.0;

  /// Creates a [ModuleModel] from a JSON map returned by the API.
  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'] as List<dynamic>? ?? [];
    return ModuleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      lessons: rawLessons
          .map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
          .toList(),
      order: json['order'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedLessons: json['completed_lessons'] as int? ?? 0,
    );
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'order': order,
      'is_completed': isCompleted,
      'completed_lessons': completedLessons,
    };
  }

  /// Returns a copy of this model with updated fields.
  ModuleModel copyWith({
    String? id,
    String? title,
    String? description,
    List<LessonModel>? lessons,
    int? order,
    bool? isCompleted,
    int? completedLessons,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      lessons: lessons ?? this.lessons,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }
}

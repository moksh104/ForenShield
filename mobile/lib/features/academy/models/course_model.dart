import 'module_model.dart';

/// Difficulty rating for a [CourseModel].
enum CourseDifficulty { beginner, intermediate, advanced }

/// Represents a top-level Academy course consisting of multiple modules.
class CourseModel {
  /// Unique identifier for the course.
  final String id;

  /// Display title.
  final String title;

  /// Short marketing description.
  final String description;

  /// URL pointing to the course thumbnail image.
  final String? thumbnailUrl;

  /// Difficulty level.
  final CourseDifficulty difficulty;

  /// Total XP available for completing the course.
  final int totalXp;

  /// Ordered list of modules.
  final List<ModuleModel> modules;

  /// Total estimated time to complete (in minutes).
  final int estimatedMinutes;

  /// Whether the user has enrolled in this course.
  final bool isEnrolled;

  /// The number of completed modules.
  final int completedModules;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.modules,
    required this.difficulty,
    this.thumbnailUrl,
    this.totalXp = 0,
    this.estimatedMinutes = 0,
    this.isEnrolled = false,
    this.completedModules = 0,
  });

  /// Total number of modules in this course.
  int get totalModules => modules.length;

  /// Overall course completion progress between 0.0 and 1.0.
  double get progress =>
      totalModules > 0 ? completedModules / totalModules : 0.0;

  /// Creates a [CourseModel] from a JSON map returned by the API.
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final rawModules = json['modules'] as List<dynamic>? ?? [];
    final difficultyStr = json['difficulty'] as String? ?? 'beginner';
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      difficulty: CourseDifficulty.values.firstWhere(
        (d) => d.name == difficultyStr,
        orElse: () => CourseDifficulty.beginner,
      ),
      totalXp: json['total_xp'] as int? ?? 0,
      modules: rawModules
          .map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      estimatedMinutes: json['estimated_minutes'] as int? ?? 0,
      isEnrolled: json['is_enrolled'] as bool? ?? false,
      completedModules: json['completed_modules'] as int? ?? 0,
    );
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'difficulty': difficulty.name,
      'total_xp': totalXp,
      'modules': modules.map((m) => m.toJson()).toList(),
      'estimated_minutes': estimatedMinutes,
      'is_enrolled': isEnrolled,
      'completed_modules': completedModules,
    };
  }

  /// Returns a copy of this model with updated fields.
  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    CourseDifficulty? difficulty,
    int? totalXp,
    List<ModuleModel>? modules,
    int? estimatedMinutes,
    bool? isEnrolled,
    int? completedModules,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      difficulty: difficulty ?? this.difficulty,
      totalXp: totalXp ?? this.totalXp,
      modules: modules ?? this.modules,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      completedModules: completedModules ?? this.completedModules,
    );
  }
}

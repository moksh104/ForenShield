import '../../domain/entities/course_entity.dart';
import 'lesson_model.dart';
import 'quiz_model.dart';

class ModuleModel extends ModuleEntity {
  const ModuleModel({
    required super.id,
    required super.title,
    required super.description,
    required List<LessonModel> super.lessons,
    required super.order,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      order: json['order'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lessons': lessons.map((l) => (l as LessonModel).toJson()).toList(),
      'order': order,
    };
  }
}

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.difficulty,
    required super.durationMinutes,
    required super.instructorName,
    required super.thumbnailUrl,
    required super.prerequisites,
    required super.learningOutcomes,
    required List<ModuleModel> super.modules,
    required super.isEnrolled,
    required super.completionPercentage,
    required super.totalXp,
    super.quiz,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final rawCompletion =
        num.tryParse(
          json['completion_percentage']?.toString() ?? '',
        )?.toDouble() ??
        0.0;
    final completionPercentage = rawCompletion > 1
        ? rawCompletion / 100
        : rawCompletion;

    return CourseModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Forensics',
      difficulty: json['difficulty'] as String? ?? 'Intermediate',
      durationMinutes: json['duration_minutes'] as int? ?? 120,
      instructorName: json['instructor_name'] as String? ?? 'Dr. Alex Vance',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      prerequisites:
          (json['prerequisites'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Basic Networking', 'Linux Command Line'],
      learningOutcomes:
          (json['learning_outcomes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Analyze RAM dumps', 'Extract registry artifacts'],
      modules:
          (json['modules'] as List<dynamic>?)
              ?.map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isEnrolled: json['is_enrolled'] as bool? ?? false,
      completionPercentage: completionPercentage.clamp(0.0, 1.0),
      totalXp: json['total_xp'] as int? ?? 500,
      quiz: json['quiz'] != null
          ? QuizModel.fromJson(json['quiz'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'duration_minutes': durationMinutes,
      'instructor_name': instructorName,
      'thumbnail_url': thumbnailUrl,
      'prerequisites': prerequisites,
      'learning_outcomes': learningOutcomes,
      'modules': modules.map((m) => (m as ModuleModel).toJson()).toList(),
      'is_enrolled': isEnrolled,
      'completion_percentage': completionPercentage,
      'total_xp': totalXp,
      'quiz': quiz != null ? (quiz as QuizModel).toJson() : null,
    };
  }
}

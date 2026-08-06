import 'package:equatable/equatable.dart';
import 'lesson_entity.dart';
import 'quiz_entity.dart';

/// Module entity grouping lessons.
class ModuleEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<LessonEntity> lessons;
  final int order;

  const ModuleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.order,
  });

  int get completedLessonsCount => lessons.where((l) => l.isCompleted).length;

  double get progress =>
      lessons.isEmpty ? 0.0 : completedLessonsCount / lessons.length;

  @override
  List<Object?> get props => [id, title, description, lessons, order];
}

/// Core Course domain entity for Cyber Academy.
class CourseEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final String instructorName;
  final String thumbnailUrl;
  final List<String> prerequisites;
  final List<String> learningOutcomes;
  final List<ModuleEntity> modules;
  final bool isEnrolled;
  final double completionPercentage;
  final int totalXp;
  final QuizEntity? quiz;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.instructorName,
    required this.thumbnailUrl,
    required this.prerequisites,
    required this.learningOutcomes,
    required this.modules,
    required this.isEnrolled,
    required this.completionPercentage,
    required this.totalXp,
    this.quiz,
  });

  CourseEntity copyWith({
    bool? isEnrolled,
    double? completionPercentage,
    List<ModuleEntity>? modules,
  }) {
    return CourseEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      difficulty: difficulty,
      durationMinutes: durationMinutes,
      instructorName: instructorName,
      thumbnailUrl: thumbnailUrl,
      prerequisites: prerequisites,
      learningOutcomes: learningOutcomes,
      modules: modules ?? this.modules,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      totalXp: totalXp,
      quiz: quiz,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    difficulty,
    durationMinutes,
    instructorName,
    thumbnailUrl,
    prerequisites,
    learningOutcomes,
    modules,
    isEnrolled,
    completionPercentage,
    totalXp,
    quiz,
  ];
}

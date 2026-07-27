import 'package:equatable/equatable.dart';

/// Checklist item in a lesson.
class LessonChecklistItemEntity extends Equatable {
  final String id;
  final String label;
  final bool isChecked;

  const LessonChecklistItemEntity({
    required this.id,
    required this.label,
    required this.isChecked,
  });

  LessonChecklistItemEntity copyWith({bool? isChecked}) {
    return LessonChecklistItemEntity(
      id: id,
      label: label,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  List<Object?> get props => [id, label, isChecked];
}

/// Lesson entity within a module.
class LessonEntity extends Equatable {
  final String id;
  final String title;
  final int durationMinutes;
  final String contentType;
  final String contentText;
  final String? imageUrl;
  final String? codeSnippet;
  final String? codeLanguage;
  final List<LessonChecklistItemEntity> checklist;
  final bool isCompleted;
  final int order;
  final String? quizId;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.contentType,
    required this.contentText,
    this.imageUrl,
    this.codeSnippet,
    this.codeLanguage,
    this.checklist = const [],
    this.isCompleted = false,
    required this.order,
    this.quizId,
  });

  LessonEntity copyWith({
    bool? isCompleted,
    List<LessonChecklistItemEntity>? checklist,
  }) {
    return LessonEntity(
      id: id,
      title: title,
      durationMinutes: durationMinutes,
      contentType: contentType,
      contentText: contentText,
      imageUrl: imageUrl,
      codeSnippet: codeSnippet,
      codeLanguage: codeLanguage,
      checklist: checklist ?? this.checklist,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order,
      quizId: quizId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        durationMinutes,
        contentType,
        contentText,
        imageUrl,
        codeSnippet,
        codeLanguage,
        checklist,
        isCompleted,
        order,
        quizId,
      ];
}

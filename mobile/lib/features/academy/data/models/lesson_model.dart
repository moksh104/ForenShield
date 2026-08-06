import '../../domain/entities/lesson_entity.dart';

class LessonChecklistItemModel extends LessonChecklistItemEntity {
  const LessonChecklistItemModel({
    required super.id,
    required super.label,
    required super.isChecked,
  });

  factory LessonChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return LessonChecklistItemModel(
      id: (json['id'] ?? '').toString(),
      label: json['label'] as String? ?? '',
      isChecked: json['is_checked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'is_checked': isChecked};
  }
}

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.durationMinutes,
    required super.contentType,
    required super.contentText,
    super.imageUrl,
    super.codeSnippet,
    super.codeLanguage,
    required List<LessonChecklistItemModel> super.checklist,
    super.isCompleted,
    required super.order,
    super.quizId,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 15,
      contentType: json['content_type'] as String? ?? 'text',
      contentText: json['content_text'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      codeSnippet: json['code_snippet'] as String?,
      codeLanguage: json['code_language'] as String?,
      checklist:
          (json['checklist'] as List<dynamic>?)
              ?.map(
                (e) => LessonChecklistItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      isCompleted: json['is_completed'] as bool? ?? false,
      order: json['order'] as int? ?? 1,
      quizId: json['quiz_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration_minutes': durationMinutes,
      'content_type': contentType,
      'content_text': contentText,
      'image_url': imageUrl,
      'code_snippet': codeSnippet,
      'code_language': codeLanguage,
      'checklist': checklist
          .map((c) => (c as LessonChecklistItemModel).toJson())
          .toList(),
      'is_completed': isCompleted,
      'order': order,
      'quiz_id': quizId,
    };
  }
}

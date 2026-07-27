import '../../domain/entities/quiz_entity.dart';

class QuizQuestionModel extends QuizQuestionEntity {
  const QuizQuestionModel({
    required super.id,
    required super.questionText,
    required super.options,
    required super.correctOptionIndex,
    required super.explanation,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String? ?? '',
      questionText: json['question_text'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      correctOptionIndex: json['correct_option_index'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'options': options,
      'correct_option_index': correctOptionIndex,
      'explanation': explanation,
    };
  }
}

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.title,
    required super.passingScorePercent,
    required List<QuizQuestionModel> super.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      passingScorePercent: json['passing_score_percent'] as int? ?? 80,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'passing_score_percent': passingScorePercent,
      'questions':
          questions.map((q) => (q as QuizQuestionModel).toJson()).toList(),
    };
  }
}

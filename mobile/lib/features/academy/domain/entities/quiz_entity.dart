import 'package:equatable/equatable.dart';

/// Question entity within a quiz.
class QuizQuestionEntity extends Equatable {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestionEntity({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props =>
      [id, questionText, options, correctOptionIndex, explanation];
}

/// Quiz entity for knowledge checks.
class QuizEntity extends Equatable {
  final String id;
  final String title;
  final int passingScorePercent;
  final List<QuizQuestionEntity> questions;

  const QuizEntity({
    required this.id,
    required this.title,
    required this.passingScorePercent,
    required this.questions,
  });

  @override
  List<Object?> get props => [id, title, passingScorePercent, questions];
}

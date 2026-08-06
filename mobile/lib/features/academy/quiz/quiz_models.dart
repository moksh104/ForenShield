import 'package:equatable/equatable.dart';

/// Supported question types
enum QuestionType { singleChoice, multipleChoice, trueFalse, dragAndDrop }

/// Option model for a question. `isCorrect` is used by the engine to score answers.
class QuizOptionModel extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;

  const QuizOptionModel({required this.id, required this.text, this.isCorrect = false});

  @override
  List<Object?> get props => [id, text, isCorrect];
}

/// Question model.
class QuizQuestionModel extends Equatable {
  final String id;
  final QuestionType type;
  final String question;
  final List<QuizOptionModel> options;

  /// Optional explanation shown after answering
  final String? explanation;

  /// Points awarded for a fully-correct answer
  final int points;

  /// XP reward for completing this question
  final int xp;

  /// For drag-and-drop, options might represent draggable items and targets are encoded in option.text or metadata
  final Map<String, dynamic>? metadata;

  const QuizQuestionModel({
    required this.id,
    required this.type,
    required this.question,
    this.options = const <QuizOptionModel>[],
    this.explanation,
    this.points = 1,
    this.xp = 0,
    this.metadata,
  });

  @override
  List<Object?> get props => [id, type, question, options, explanation, points, xp, metadata];
}

/// Result for a single question submission
class QuestionResult extends Equatable {
  final String questionId;
  final bool correct;
  final int pointsEarned;
  final int xpEarned;
  final String? explanation;

  const QuestionResult({required this.questionId, required this.correct, required this.pointsEarned, required this.xpEarned, this.explanation});

  @override
  List<Object?> get props => [questionId, correct, pointsEarned, xpEarned, explanation];
}

/// Final quiz result summary
class QuizResult extends Equatable {
  final int totalQuestions;
  final int correctAnswers;
  final int score; // points
  final int xp;

  const QuizResult({required this.totalQuestions, required this.correctAnswers, required this.score, required this.xp});

  @override
  List<Object?> get props => [totalQuestions, correctAnswers, score, xp];
}

import 'package:equatable/equatable.dart';

/// Model for content used in lesson player
class LessonContent extends Equatable {
  final String markdown;
  final List<String> imageUrls;

  const LessonContent({required this.markdown, this.imageUrls = const []});

  @override
  List<Object?> get props => [markdown, imageUrls];
}

/// Quiz models
class QuizOption extends Equatable {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<QuizOption> options;
  final String? correctOptionId; // optional - UI does not use this for logic

  const QuizQuestion({required this.id, required this.question, this.options = const <QuizOption>[], this.correctOptionId});

  @override
  List<Object?> get props => [id, question, options, correctOptionId];
}

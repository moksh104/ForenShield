import 'dart:async';

import 'package:collection/collection.dart';

import 'quiz_models.dart';

/// Lightweight quiz engine that encapsulates quiz logic separately from UI.
///
/// - Pure Dart logic
/// - Emits QuizState updates via stream
/// - Supports single/multiple/true-false and is future-ready for drag-and-drop
/// - Scoring: full points when the submitted answer exactly matches the correct set of options.
///   For multiple-choice partial scoring can be enabled via [allowPartialScoring].
class QuizState {
  final int currentIndex;
  final int totalQuestions;
  final Map<String, List<String>> selectedOptions; // questionId -> list of optionIds
  final Map<String, QuestionResult> results; // questionId -> result
  final bool completed;
  final int score;
  final int xp;

  const QuizState({required this.currentIndex, required this.totalQuestions, required this.selectedOptions, required this.results, required this.completed, required this.score, required this.xp});

  QuizState copyWith({int? currentIndex, Map<String, List<String>>? selectedOptions, Map<String, QuestionResult>? results, bool? completed, int? score, int? xp}) {
    return QuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      totalQuestions: totalQuestions,
      selectedOptions: selectedOptions ?? Map<String, List<String>>.from(this.selectedOptions),
      results: results ?? Map<String, QuestionResult>.from(this.results),
      completed: completed ?? this.completed,
      score: score ?? this.score,
      xp: xp ?? this.xp,
    );
  }
}

class QuizEngine {
  final List<QuizQuestionModel> _questions;
  final bool allowPartialScoring;
  final StreamController<QuizState> _controller = StreamController.broadcast();

  late QuizState _state;

  QuizEngine(List<QuizQuestionModel> questions, {this.allowPartialScoring = false}) : _questions = List.unmodifiable(questions) {
    _state = QuizState(currentIndex: 0, totalQuestions: _questions.length, selectedOptions: <String, List<String>>{}, results: <String, QuestionResult>{}, completed: false, score: 0, xp: 0);
  }

  /// Stream of state updates. UI can listen to this stream to rebuild.
  Stream<QuizState> get onStateChanged => _controller.stream;

  QuizState get state => _state;

  QuizQuestionModel get currentQuestion => _questions[_state.currentIndex];

  /// Select or toggle an option for the current question.
  void toggleOption(String optionId) {
    _toggleOptionForQuestion(currentQuestion.id, optionId);
  }

  /// Directly set selection for a question (used by UI for arbitrary question index)
  void setSelection(String questionId, List<String> optionIds) {
    _state.selectedOptions[questionId] = List<String>.from(optionIds);
    _emit();
  }

  /// Submit answer for the current question. Returns QuestionResult.
  QuestionResult submitCurrent() {
    return submitAnswerForQuestion(currentQuestion.id);
  }

  /// Submit answer for a specific question id.
  QuestionResult submitAnswerForQuestion(String questionId) {
    final q = _questions.firstWhereOrNull((e) => e.id == questionId);
    if (q == null) {
      throw ArgumentError('Question not found: $questionId');
    }

    final selected = _state.selectedOptions[questionId] ?? <String>[];

    final correctOptionIds = q.options.where((o) => o.isCorrect).map((o) => o.id).toList();

    bool correct = false;
    int pointsEarned = 0;
    int xpEarned = 0;

    if (q.type == QuestionType.singleChoice || q.type == QuestionType.trueFalse) {
      correct = selected.length == 1 && correctOptionIds.contains(selected.first);
      if (correct) {
        pointsEarned = q.points;
        xpEarned = q.xp;
      }
    } else if (q.type == QuestionType.multipleChoice) {
      final eq = const ListEquality<String>();
      if (eq.equals(selected..sort(), correctOptionIds..sort())) {
        correct = true;
        pointsEarned = q.points;
        xpEarned = q.xp;
      } else if (allowPartialScoring && correctOptionIds.isNotEmpty) {
        // simple partial scoring: proportion of correct selections minus incorrect selections, floored at 0
        final selectedSet = selected.toSet();
        final correctSet = correctOptionIds.toSet();
        final correctlySelected = selectedSet.intersection(correctSet).length;
        final incorrectlySelected = selectedSet.difference(correctSet).length;
        final raw = (correctlySelected - incorrectlySelected) / correctSet.length;
        final ratio = raw.clamp(0.0, 1.0);
        pointsEarned = (q.points * ratio).round();
        xpEarned = (q.xp * ratio).round();
        correct = pointsEarned > 0;
      }
    } else if (q.type == QuestionType.dragAndDrop) {
      // Future ready: expect selection to be encoded as mapping strings in metadata into selected list like "srcId:targetId"
      // Simple exact match scoring here
      final expectedPairs = (q.metadata?['pairs'] as List<dynamic>?)?.cast<Map<String, String>>() ?? <Map<String, String>>[];
      final submittedPairs = selected.map((s) {
        final parts = s.split(':');
        return {'from': parts[0], 'to': parts.length > 1 ? parts[1] : ''};
      }).toList();
      if (const DeepCollectionEquality().equals(expectedPairs, submittedPairs)) {
        correct = true;
        pointsEarned = q.points;
        xpEarned = q.xp;
      }
    }

    final result = QuestionResult(questionId: q.id, correct: correct, pointsEarned: pointsEarned, xpEarned: xpEarned, explanation: q.explanation);

    _state.results[q.id] = result;
    _state = _state.copyWith(score: _state.score + pointsEarned, xp: _state.xp + xpEarned, results: _state.results);

    // If all questions answered, mark completed
    if (_state.results.length >= _questions.length) {
      _state = _state.copyWith(completed: true);
    }

    _emit();
    return result;
  }

  /// Move to next question, if available
  void next() {
    if (_state.currentIndex < _questions.length - 1) {
      _state = _state.copyWith(currentIndex: _state.currentIndex + 1);
      _emit();
    }
  }

  /// Move to previous question
  void previous() {
    if (_state.currentIndex > 0) {
      _state = _state.copyWith(currentIndex: _state.currentIndex - 1);
      _emit();
    }
  }

  /// Reset quiz (clears selections and results)
  void reset() {
    _state = QuizState(currentIndex: 0, totalQuestions: _questions.length, selectedOptions: <String, List<String>>{}, results: <String, QuestionResult>{}, completed: false, score: 0, xp: 0);
    _emit();
  }

  void dispose() {
    _controller.close();
  }

  void _toggleOptionForQuestion(String questionId, String optionId) {
    final q = _questions.firstWhere((e) => e.id == questionId);
    final selected = _state.selectedOptions[questionId] ?? <String>[];
    if (q.type == QuestionType.singleChoice || q.type == QuestionType.trueFalse) {
      // replace
      _state.selectedOptions[questionId] = [optionId];
    } else if (q.type == QuestionType.multipleChoice || q.type == QuestionType.dragAndDrop) {
      final set = selected.toSet();
      if (set.contains(optionId)) set.remove(optionId);
      else set.add(optionId);
      _state.selectedOptions[questionId] = set.toList();
    }
    _emit();
  }

  void _emit() {
    try {
      _controller.add(_state);
    } catch (_) {}
  }
}

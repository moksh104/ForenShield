import 'package:equatable/equatable.dart';

/// Domain entity for submitting and scoring investigation verdicts.
class VerdictEntity extends Equatable {
  final String id;
  final String caseId;
  final String summaryText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanationText;
  final int xpReward;

  const VerdictEntity({
    required this.id,
    required this.caseId,
    required this.summaryText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanationText,
    required this.xpReward,
  });

  @override
  List<Object?> get props => [
    id,
    caseId,
    summaryText,
    options,
    correctOptionIndex,
    explanationText,
    xpReward,
  ];
}

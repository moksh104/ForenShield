import '../../domain/entities/verdict_entity.dart';

class VerdictModel extends VerdictEntity {
  const VerdictModel({
    required super.id,
    required super.caseId,
    required super.summaryText,
    required super.options,
    required super.correctOptionIndex,
    required super.explanationText,
    required super.xpReward,
  });

  factory VerdictModel.fromJson(Map<String, dynamic> json) {
    return VerdictModel(
      id: (json['id'] ?? '').toString(),
      caseId: (json['case_id'] ?? '').toString(),
      summaryText: json['summary_text'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      correctOptionIndex: json['correct_option_index'] as int? ?? 0,
      explanationText: json['explanation_text'] as String? ?? '',
      xpReward: json['xp_reward'] as int? ?? 500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_id': caseId,
      'summary_text': summaryText,
      'options': options,
      'correct_option_index': correctOptionIndex,
      'explanation_text': explanationText,
      'xp_reward': xpReward,
    };
  }
}

import 'package:equatable/equatable.dart';

/// Model representing aggregate learning progress for a user/course.
///
/// - Immutable, const constructor
/// - Manual fromJson/toJson
/// - copyWith
class LearningProgressModel extends Equatable {
  /// Identifier for the course this progress belongs to (optional)
  final String? courseId;

  /// Total target minutes expected
  final int totalMinutes;

  /// Minutes completed so far
  final int completedMinutes;

  /// Number of badges earned
  final int badgesEarned;

  /// Number of total available badges (for progress calculation)
  final int totalBadges;

  /// Current learning streak in days
  final int streakDays;

  const LearningProgressModel({this.courseId, this.totalMinutes = 0, this.completedMinutes = 0, this.badgesEarned = 0, this.totalBadges = 0, this.streakDays = 0});

  /// Convenience getter for percent completed (0.0 - 1.0). Returns 0 when totalMinutes is 0.
  double get percent => totalMinutes == 0 ? 0.0 : (completedMinutes / totalMinutes).clamp(0.0, 1.0);

  factory LearningProgressModel.fromJson(Map<String, dynamic> json) {
    return LearningProgressModel(
      courseId: json['courseId'] as String?,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      completedMinutes: json['completedMinutes'] as int? ?? 0,
      badgesEarned: json['badgesEarned'] as int? ?? 0,
      totalBadges: json['totalBadges'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'totalMinutes': totalMinutes,
        'completedMinutes': completedMinutes,
        'badgesEarned': badgesEarned,
        'totalBadges': totalBadges,
        'streakDays': streakDays,
      };

  LearningProgressModel copyWith({String? courseId, int? totalMinutes, int? completedMinutes, int? badgesEarned, int? totalBadges, int? streakDays}) {
    return LearningProgressModel(
      courseId: courseId ?? this.courseId,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      completedMinutes: completedMinutes ?? this.completedMinutes,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      totalBadges: totalBadges ?? this.totalBadges,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  List<Object?> get props => [courseId, totalMinutes, completedMinutes, badgesEarned, totalBadges, streakDays];
}

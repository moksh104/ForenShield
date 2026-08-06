import '../models/course_model.dart';
import '../models/lesson_model.dart';

/// Utility helpers for the Cyber Academy feature.
///
/// All methods are pure functions with no side effects.
class AcademyUtils {
  AcademyUtils._();

  /// Returns a human-readable difficulty label for a [CourseDifficulty].
  static String difficultyLabel(CourseDifficulty difficulty) {
    switch (difficulty) {
      case CourseDifficulty.beginner:
        return 'Beginner';
      case CourseDifficulty.intermediate:
        return 'Intermediate';
      case CourseDifficulty.advanced:
        return 'Advanced';
    }
  }

  /// Formats a duration in minutes into a short readable string.
  ///
  /// Examples:
  /// - 45 → '45 min'
  /// - 90 → '1h 30m'
  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    if (remaining == 0) return '${hours}h';
    return '${hours}h ${remaining}m';
  }

  /// Returns a human-readable content type label for a [LessonModel].
  static String contentTypeLabel(String contentType) {
    switch (contentType) {
      case 'video':
        return 'Video';
      case 'quiz':
        return 'Quiz';
      case 'lab':
        return 'Lab';
      case 'reading':
      default:
        return 'Reading';
    }
  }

  /// Returns the icon name string for a given content type.
  static String contentTypeIcon(String contentType) {
    switch (contentType) {
      case 'video':
        return 'play_circle_outline';
      case 'quiz':
        return 'quiz_outlined';
      case 'lab':
        return 'terminal_outlined';
      case 'reading':
      default:
        return 'article_outlined';
    }
  }

  /// Returns the total number of completed lessons across all modules.
  static int totalCompletedLessons(CourseModel course) {
    return course.modules.fold(
      0,
      (sum, module) => sum + module.completedLessons,
    );
  }

  /// Returns the total number of lessons across all modules.
  static int totalLessons(CourseModel course) {
    return course.modules.fold(0, (sum, module) => sum + module.totalLessons);
  }
}

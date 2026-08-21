import '../domain/entities/course_entity.dart';
import '../domain/entities/lesson_entity.dart';

class MitreTechniqueModel {
  final CourseEntity course;
  final String techniqueId;
  final String tactic;
  final String platform;

  const MitreTechniqueModel({
    required this.course,
    required this.techniqueId,
    required this.tactic,
    required this.platform,
  });

  factory MitreTechniqueModel.fromJson(Map<String, dynamic> json) {
    final techniqueId = json['id'] as String? ?? 'UNKNOWN';
    final name = json['name'] as String? ?? 'Unnamed Technique';
    final tactic = json['tactic'] as String? ?? 'Unknown Tactic';
    final platform = json['platform'] as String? ?? 'Unknown Platform';
    final description = json['description'] as String? ?? 'No description.';
    final detection = json['detection'] as String? ?? '';
    final mitigation = json['mitigation'] as String? ?? '';

    // Split detection text into bullet points for Learning Outcomes
    final detectionBullets = detection
        .split(RegExp(r'\. |\.\n|\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => s.endsWith('.') ? s : '$s.')
        .take(5)
        .toList();
    if (detectionBullets.isEmpty) {
      detectionBullets.add('No specific detection guidance provided.');
    }

    // Map mitigation text into a single Module with a Lesson
    final mitigationModule = ModuleEntity(
      id: '${techniqueId}_mitigation',
      title: 'Mitigation Details',
      description: 'Consult MITRE ATT&CK portal for more specific steps.',
      order: 1,
      lessons: [
        LessonEntity(
          id: '${techniqueId}_mitigation_1',
          title: 'Review Mitigation Strategy',
          durationMinutes: 5,
          contentType: 'text',
          contentText: mitigation,
          isCompleted: false,
          order: 1,
        ),
      ],
    );

    // Map to CourseEntity using Composition
    final course = CourseEntity(
      id: techniqueId,
      title: '[$techniqueId] $name',
      description: description,
      category: tactic, // Maps to Category Filter
      difficulty: tactic, // Maps to the Difficulty Badge on the Card
      durationMinutes: 0,
      instructorName: platform, // Maps to Instructor Name (or platform)
      thumbnailUrl: '',
      prerequisites: const [],
      learningOutcomes: detectionBullets,
      modules: [mitigationModule],
      isEnrolled: false,
      completionPercentage: 0.0,
      totalXp: 100,
      quiz: null,
    );

    return MitreTechniqueModel(
      course: course,
      techniqueId: techniqueId,
      tactic: tactic,
      platform: platform,
    );
  }
}

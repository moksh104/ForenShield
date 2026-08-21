import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/features/academy/data/models/course_model.dart';

void main() {
  test('normalizes percentage values from the API contract', () {
    final course = CourseModel.fromJson({
      'id': 'course-1',
      'title': 'Course',
      'completion_percentage': 65,
      'modules': [],
    });

    expect(course.completionPercentage, 0.65);
  });

  test('preserves fractional progress and nested lesson IDs', () {
    final course = CourseModel.fromJson({
      'id': 'course-1',
      'title': 'Course',
      'completion_percentage': 0.75,
      'modules': [
        {
          'id': 'module-1',
          'title': 'Module 1',
          'order': 1,
          'lessons': [
            {
              'id': 'lesson-1',
              'title': 'Lesson 1',
              'duration_minutes': 20,
              'content_type': 'text',
              'content_text': 'Content',
              'order': 1,
            },
          ],
        },
      ],
    });

    expect(course.completionPercentage, 0.75);
    expect(course.modules.single.id, 'module-1');
    expect(course.modules.single.lessons.single.id, 'lesson-1');
  });
}

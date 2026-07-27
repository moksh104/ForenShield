import '../../../../core/utils/result.dart';
import '../entities/lesson_entity.dart';
import '../repositories/course_repository.dart';

/// UseCase to load a specific lesson.
class LoadLessonUseCase {
  final CourseRepository _repository;

  const LoadLessonUseCase(this._repository);

  Future<Result<LessonEntity>> call(String lessonId) async {
    return await _repository.getLesson(lessonId);
  }
}

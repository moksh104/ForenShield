import '../../../../core/utils/result.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

/// UseCase to load Cyber Academy courses.
class LoadCoursesUseCase {
  final CourseRepository _repository;

  const LoadCoursesUseCase(this._repository);

  Future<Result<List<CourseEntity>>> call({
    String? category,
    String? searchQuery,
  }) async {
    return await _repository.getCourses(
      category: category,
      searchQuery: searchQuery,
    );
  }
}

import '../../../../core/utils/result.dart';
import '../repositories/course_repository.dart';

/// UseCase to submit quiz answers and return score percentage.
class SubmitQuizUseCase {
  final CourseRepository _repository;

  const SubmitQuizUseCase(this._repository);

  Future<Result<int>> call({
    required String quizId,
    required Map<String, int> selectedOptions,
  }) async {
    return await _repository.submitQuiz(
      quizId: quizId,
      selectedOptions: selectedOptions,
    );
  }
}

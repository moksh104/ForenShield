import '../../../../core/utils/result.dart';
import '../entities/mission_control_entity.dart';
import '../repositories/mission_control_repository.dart';

/// UseCase to load dashboard data for Mission Control.
class LoadDashboardUseCase {
  final MissionControlRepository _repository;

  const LoadDashboardUseCase(this._repository);

  Future<Result<MissionControlEntity>> call() async {
    return await _repository.getDashboardData();
  }
}

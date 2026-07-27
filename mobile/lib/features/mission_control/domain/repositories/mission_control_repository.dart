import '../../../../core/utils/result.dart';
import '../entities/mission_control_entity.dart';

/// Contract interface for Mission Control repository.
abstract class MissionControlRepository {
  /// Fetches the latest Mission Control dashboard state.
  Future<Result<MissionControlEntity>> getDashboardData();
}

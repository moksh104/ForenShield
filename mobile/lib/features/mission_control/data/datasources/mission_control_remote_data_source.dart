import '../../../../core/network/api_client.dart';
import '../models/mission_control_model.dart';

/// Remote data source for Mission Control API calls.
class MissionControlRemoteDataSource {
  final ApiClient _apiClient;

  const MissionControlRemoteDataSource(this._apiClient);

  /// Fetches dashboard data from backend API endpoint.
  Future<MissionControlModel> getDashboardData() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/mission_control.php',
      );
      if (response.data != null) {
        return MissionControlModel.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback to initial mock model if server endpoint is unavailable
    }
    return MissionControlModel.fromJson(const {});
  }
}

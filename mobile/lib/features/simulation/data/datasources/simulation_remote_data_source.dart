import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/simulation_scenario.dart';
import '../models/simulation_action_result_model.dart';
import 'simulation_mock_data.dart';

class SimulationRemoteDataSource {
  final ApiClient _apiClient;

  const SimulationRemoteDataSource(this._apiClient);

  Future<List<SimulationScenario>> getScenarios() async {
    if (ApiConfig.useMockApi) {
      return SimulationMockData.scenarios;
    }
    final response = await _apiClient.get<List<dynamic>>(
      '/simulation_scenarios.php',
    );
    if (response.data != null) {
      return response.data!
          .map((e) => SimulationScenario.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ApiException('Invalid scenarios data received');
  }

  Future<SimulationStartResponse> startAttempt(
    String scenarioId, {
    bool forceNew = false,
  }) async {
    if (ApiConfig.useMockApi) {
      throw const ApiException('Mock API does not support branching attempts');
    }
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/simulation_start.php',
      data: {'scenario_id': scenarioId, 'force_new': forceNew},
    );
    if (response.data != null && response.data!['success'] == true) {
      return SimulationStartResponse.fromJson(response.data!);
    }
    final msg = response.data?['error']?.toString() ?? 'Failed to start attempt';
    throw ApiException(msg);
  }

  Future<SimulationActionResult> submitAction(
    String attemptId,
    String actionId,
  ) async {
    if (ApiConfig.useMockApi) {
      throw const ApiException('Mock API does not support simulation actions');
    }
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/simulation_action.php',
      data: {'attempt_id': attemptId, 'action_id': actionId},
    );
    if (response.data != null && response.data!['success'] == true) {
      return SimulationActionResult.fromJson(response.data!);
    }
    final msg =
        response.data?['error']?.toString() ?? 'Failed to execute action';
    throw ApiException(msg);
  }

  Future<SimulationStartResponse?> getAttempt(String scenarioId) async {
    if (ApiConfig.useMockApi) {
      return null;
    }
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/simulation_attempt.php',
      queryParameters: {'scenario_id': scenarioId},
    );
    if (response.data != null && response.data!['has_active_attempt'] == true) {
      return SimulationStartResponse.fromJson(response.data!);
    }
    return null;
  }

  Future<void> resetAttempt(String scenarioId) async {
    if (ApiConfig.useMockApi) {
      return;
    }
    await _apiClient.post<Map<String, dynamic>>(
      '/simulation_reset.php',
      data: {'scenario_id': scenarioId},
    );
  }

  Future<void> completeScenario(String scenarioId) async {
    if (ApiConfig.useMockApi) {
      return;
    }
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/simulation_complete.php',
      data: {'scenario_id': scenarioId},
    );
    if (response.data != null && response.data!['success'] == true) {
      return;
    }
    throw const ApiException('Failed to complete scenario on server');
  }
}

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/simulation_scenario.dart';
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

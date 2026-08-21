import '../../../../core/utils/result.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/simulation_scenario.dart';
import '../datasources/simulation_remote_data_source.dart';

abstract class SimulationRepository {
  Future<Result<List<SimulationScenario>>> getScenarios();
  Future<Result<void>> completeScenario(String scenarioId);
}

class SimulationRepositoryImpl implements SimulationRepository {
  final SimulationRemoteDataSource _remoteDataSource;

  SimulationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<SimulationScenario>>> getScenarios() async {
    try {
      final scenarios = await _remoteDataSource.getScenarios();
      return Success(scenarios);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> completeScenario(String scenarioId) async {
    try {
      await _remoteDataSource.completeScenario(scenarioId);
      return const Success(null);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

import '../../../../core/utils/result.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/simulation_scenario.dart';
import '../datasources/simulation_remote_data_source.dart';
import '../models/simulation_action_result_model.dart';

abstract class SimulationRepository {
  Future<Result<List<SimulationScenario>>> getScenarios();
  Future<Result<SimulationStartResponse>> startAttempt(
    String scenarioId, {
    bool forceNew = false,
  });
  Future<Result<SimulationActionResult>> submitAction(
    String attemptId,
    String actionId,
  );
  Future<Result<SimulationStartResponse?>> getAttempt(String scenarioId);
  Future<Result<void>> resetAttempt(String scenarioId);
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
  Future<Result<SimulationStartResponse>> startAttempt(
    String scenarioId, {
    bool forceNew = false,
  }) async {
    try {
      final res = await _remoteDataSource.startAttempt(
        scenarioId,
        forceNew: forceNew,
      );
      return Success(res);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<SimulationActionResult>> submitAction(
    String attemptId,
    String actionId,
  ) async {
    try {
      final res = await _remoteDataSource.submitAction(attemptId, actionId);
      return Success(res);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<SimulationStartResponse?>> getAttempt(String scenarioId) async {
    try {
      final res = await _remoteDataSource.getAttempt(scenarioId);
      return Success(res);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> resetAttempt(String scenarioId) async {
    try {
      await _remoteDataSource.resetAttempt(scenarioId);
      return const Success(null);
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

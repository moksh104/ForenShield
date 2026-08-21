import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/simulation_remote_data_source.dart';
import '../data/repositories/simulation_repository_impl.dart';
import '../domain/entities/simulation_scenario.dart';

final simulationRemoteDataSourceProvider = Provider<SimulationRemoteDataSource>(
  (ref) {
    final apiClient = ref.watch(apiClientProvider);
    return SimulationRemoteDataSource(apiClient);
  },
);

final simulationRepositoryProvider = Provider<SimulationRepository>((ref) {
  final remoteDataSource = ref.watch(simulationRemoteDataSourceProvider);
  return SimulationRepositoryImpl(remoteDataSource);
});

final simulationScenariosProvider = FutureProvider<List<SimulationScenario>>((
  ref,
) async {
  final repository = ref.watch(simulationRepositoryProvider);
  final result = await repository.getScenarios();

  return result.when(success: (data) => data, failure: (error) => throw error);
});

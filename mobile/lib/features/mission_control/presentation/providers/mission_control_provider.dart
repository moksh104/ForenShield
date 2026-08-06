import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/mission_control_remote_data_source.dart';
import '../../data/repositories/mission_control_repository_impl.dart';
import '../../data/repositories/mock_mission_control_repository.dart';
import '../../domain/entities/mission_control_entity.dart';
import '../../domain/repositories/mission_control_repository.dart';
import '../../domain/usecases/load_dashboard_use_case.dart';

/// Status enum for Mission Control state.
enum MissionControlStatus {
  initial,
  loading,
  refreshing,
  success,
  empty,
  error,
}

/// Immutable state for Mission Control Dashboard.
class MissionControlState {
  final MissionControlStatus status;
  final MissionControlEntity? data;
  final String? errorMessage;

  const MissionControlState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory MissionControlState.initial() =>
      const MissionControlState(status: MissionControlStatus.initial);

  MissionControlState copyWith({
    MissionControlStatus? status,
    MissionControlEntity? data,
    String? errorMessage,
  }) {
    return MissionControlState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider for Remote Data Source.
final missionControlRemoteDataSourceProvider =
    Provider<MissionControlRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return MissionControlRemoteDataSource(apiClient);
    });

/// Provider for Repository contract.
final missionControlRepositoryProvider = Provider<MissionControlRepository>((
  ref,
) {
  if (ApiConfig.useMockApi) {
    return MockMissionControlRepository();
  }
  final dataSource = ref.watch(missionControlRemoteDataSourceProvider);
  return MissionControlRepositoryImpl(dataSource);
});

/// Provider for LoadDashboardUseCase.
final loadDashboardUseCaseProvider = Provider<LoadDashboardUseCase>((ref) {
  final repository = ref.watch(missionControlRepositoryProvider);
  return LoadDashboardUseCase(repository);
});

/// Notifier for Mission Control Dashboard state management.
class MissionControlNotifier extends StateNotifier<MissionControlState> {
  final LoadDashboardUseCase _loadDashboardUseCase;

  MissionControlNotifier(this._loadDashboardUseCase)
    : super(MissionControlState.initial()) {
    loadDashboard();
  }

  /// Loads initial dashboard data.
  Future<void> loadDashboard() async {
    state = state.copyWith(status: MissionControlStatus.loading);
    final result = await _loadDashboardUseCase();
    if (!mounted) return;
    result.when(
      success: (data) {
        state = state.copyWith(
          status: MissionControlStatus.success,
          data: data,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          status: MissionControlStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  /// Refreshes dashboard data for Pull-to-Refresh.
  Future<void> refreshDashboard() async {
    state = state.copyWith(status: MissionControlStatus.refreshing);
    final result = await _loadDashboardUseCase();
    if (!mounted) return;
    result.when(
      success: (data) {
        state = state.copyWith(
          status: MissionControlStatus.success,
          data: data,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          status: MissionControlStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }
}

/// Main StateNotifierProvider for Mission Control.
final missionControlProvider =
    StateNotifierProvider.autoDispose<
      MissionControlNotifier,
      MissionControlState
    >((ref) {
      final useCase = ref.watch(loadDashboardUseCaseProvider);
      return MissionControlNotifier(useCase);
    });

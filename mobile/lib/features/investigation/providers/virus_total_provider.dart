import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/virus_total_remote_data_source.dart';
import '../data/repositories/virus_total_repository.dart';
import '../models/virus_total_model.dart';

final virusTotalRemoteDataSourceProvider = Provider<VirusTotalRemoteDataSource>(
  (ref) {
    final apiClient = ref.watch(apiClientProvider);
    return VirusTotalRemoteDataSource(apiClient);
  },
);

final virusTotalRepositoryProvider = Provider<VirusTotalRepository>((ref) {
  final remoteDataSource = ref.watch(virusTotalRemoteDataSourceProvider);
  return VirusTotalRepository(remoteDataSource);
});

final virusTotalProvider =
    AutoDisposeFutureProvider.family<VirusTotalModel, String>((
      ref,
      query,
    ) async {
      final repository = ref.watch(virusTotalRepositoryProvider);
      final result = await repository.getAnalysis(query);

      return result.when(
        success: (analysis) => analysis,
        failure: (error) {
          throw error;
        },
      );
    });

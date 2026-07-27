import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../datasource/academy_remote_data_source.dart';
import '../repository/academy_repository.dart';

/// Provides the [AcademyRemoteDataSource] scoped to the Academy feature.
final academyRemoteDataSourceProvider =
    Provider<AcademyRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AcademyRemoteDataSource(apiClient);
});

/// Provides the [AcademyRepository] scoped to the Academy feature.
final academyRepositoryProvider = Provider<AcademyRepository>((ref) {
  final dataSource = ref.watch(academyRemoteDataSourceProvider);
  return AcademyRepository(dataSource);
});

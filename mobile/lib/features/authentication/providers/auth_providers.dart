import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/api_config.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasource/auth_remote_data_source.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/mock_auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (ApiConfig.useMockApi) {
    return MockAuthRepository();
  }
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

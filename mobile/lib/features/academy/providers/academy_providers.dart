import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/academy_remote_data_source.dart';
import '../data/academy_repository.dart';

/// Provider for AcademyRemoteDataSource
final academyRemoteDataSourceProvider = Provider<AcademyRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AcademyRemoteDataSource(apiClient);
});

/// Provider for AcademyRepository
final academyRepositoryProvider = Provider<AcademyRepository>((ref) {
  final remote = ref.read(academyRemoteDataSourceProvider);
  return AcademyRepository(remote);
});

/// Example convenience FutureProviders that UI can consume. These are simple wrappers that call repository methods
/// and return Result<T>. Keep UI logic out of these providers.
final featuredCoursesProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(academyRepositoryProvider);
  return repo.getFeaturedCourses();
});

final recommendedCoursesProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(academyRepositoryProvider);
  return repo.getRecommendedCourses();
});

final categoriesProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(academyRepositoryProvider);
  return repo.getCategories();
});

final recentLessonsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(academyRepositoryProvider);
  return repo.getRecentLessons();
});

final achievementsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(academyRepositoryProvider);
  return repo.getAchievements();
});

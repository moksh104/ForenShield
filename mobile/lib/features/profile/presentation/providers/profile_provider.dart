import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/upload_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../authentication/providers/auth_state_provider.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/mock_profile_repository.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/load_profile_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';

enum ProfileStatus { initial, loading, refreshing, success, empty, error }

class ProfileState {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;

  const ProfileState({required this.status, this.profile, this.errorMessage});

  factory ProfileState.initial() =>
      const ProfileState(status: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Dependency Providers ─────────────────────────────────────────────────────

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSource(apiClient);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  if (ApiConfig.useMockApi) {
    return MockProfileRepository();
  }
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
});

final loadProfileUseCaseProvider = Provider<LoadProfileUseCase>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return LoadProfileUseCase(repo);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return UpdateProfileUseCase(repo);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final authNotifier = ref.read(authStateProvider.notifier);
  return LogoutUseCase(authNotifier);
});

// ── State Notifier Provider ───────────────────────────────────────────────────

class ProfileNotifier extends StateNotifier<ProfileState> {
  final LoadProfileUseCase _loadProfileUseCase;
  final Ref _ref;

  ProfileNotifier(this._loadProfileUseCase, this._ref)
    : super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);
    final result = await _loadProfileUseCase();
    if (!mounted) return;

    result.when(
      success: (profile) {
        state = state.copyWith(status: ProfileStatus.success, profile: profile);
      },
      failure: (exception) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }

  Future<void> updateAvatar(String avatarPath) async {
    if (state.profile == null) return;

    // Set to loading to show progress indicator if UI supports it
    state = state.copyWith(status: ProfileStatus.loading);

    String finalUrl = avatarPath;

    // Upload if it's a local file path
    if (avatarPath.isNotEmpty && !avatarPath.startsWith('http')) {
      final uploadService = _ref.read(uploadServiceProvider);
      final file = File(avatarPath);
      final compressed = await uploadService.compressImage(file);
      final url = await uploadService.uploadImage(
        compressed ?? file,
        folder: 'forenshield/users',
      );

      if (url == null) {
        if (!mounted) return;
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to upload image',
        );
        return;
      }
      finalUrl = url;
    }

    final updateUseCase = _ref.read(updateProfileUseCaseProvider);
    final result = await updateUseCase(
      fullName: state.profile!.fullName,
      email: state.profile!.email,
      bio: state.profile!.bio,
      phone: state.profile!.phone,
      avatarUrl: finalUrl,
    );

    if (!mounted) return;

    result.when(
      success: (updated) {
        state = state.copyWith(status: ProfileStatus.success, profile: updated);
      },
      failure: (e) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString(),
        );
      },
    );
  }

  Future<void> removeAvatar() async {
    if (state.profile?.avatarUrl != null &&
        state.profile!.avatarUrl.startsWith('http')) {
      // Optional: Delete from Cloudinary using UploadService
      // Assuming publicId can be extracted or not needed right now
    }
    await updateAvatar('');
  }

  Future<void> refreshProfile() async {
    state = state.copyWith(status: ProfileStatus.refreshing);
    final result = await _loadProfileUseCase();
    if (!mounted) return;

    result.when(
      success: (profile) {
        state = state.copyWith(status: ProfileStatus.success, profile: profile);
      },
      failure: (exception) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: exception.toString(),
        );
      },
    );
  }
}

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, ProfileState>((ref) {
      final useCase = ref.watch(loadProfileUseCaseProvider);
      return ProfileNotifier(useCase, ref);
    });

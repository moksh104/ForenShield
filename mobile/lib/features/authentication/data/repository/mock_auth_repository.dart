import '../../../../core/utils/result.dart';
import '../../../../models/auth_response_model.dart';
import '../../../../models/user_model.dart';
import 'auth_repository.dart';

/// Offline mock implementation of [AuthRepository].
class MockAuthRepository implements AuthRepository {
  static final UserModel _mockUser = UserModel(
    id: 'user_mock_001',
    email: 'samlee.mobbin@gmail.com',
    displayName: 'Sam Lee',
    avatarUrl: null,
    totalXp: 4250,
    rank: 'Senior Cyber Investigator',
    currentStreak: 7,
    createdAt: DateTime(2025, 1, 15),
  );

  static final AuthResponseModel _mockAuthResponse = AuthResponseModel(
    accessToken: 'mock_jwt_access_token_header.payload.signature',
    refreshToken: 'mock_jwt_refresh_token_header.payload.signature',
    user: _mockUser,
  );

  @override
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final customUser = _mockUser.copyWith(email: email);
    return Success(
      AuthResponseModel(
        accessToken: _mockAuthResponse.accessToken,
        refreshToken: _mockAuthResponse.refreshToken,
        user: customUser,
      ),
    );
  }

  @override
  Future<Result<AuthResponseModel>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newUser = _mockUser.copyWith(
      email: email,
      displayName: displayName.isNotEmpty ? displayName : 'Cadet Investigator',
    );
    return Success(
      AuthResponseModel(
        accessToken: _mockAuthResponse.accessToken,
        refreshToken: _mockAuthResponse.refreshToken,
        user: newUser,
      ),
    );
  }

  @override
  Future<Result<bool>> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const Success(true);
  }

  @override
  Future<Result<AuthResponseModel>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final customUser = _mockUser.copyWith(email: email);
    return Success(
      AuthResponseModel(
        accessToken: _mockAuthResponse.accessToken,
        refreshToken: _mockAuthResponse.refreshToken,
        user: customUser,
      ),
    );
  }

  @override
  Future<Result<void>> logout({String? refreshToken}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Success(null);
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Success(_mockUser);
  }
}

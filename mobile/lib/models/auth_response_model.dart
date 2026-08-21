import 'package:equatable/equatable.dart';
import 'user_model.dart';

/// Authentication response from the ForenShield PHP REST API.
///
/// Returned by POST /auth/login and POST /auth/register.
/// Contains a short-lived JWT [accessToken] and a long-lived [refreshToken]
/// used by [AuthInterceptor] to silently renew sessions.
class AuthResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user];

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: (json['accessToken'] ?? json['access_token'] ?? '')
          .toString(),
      refreshToken: (json['refreshToken'] ?? json['refresh_token'] ?? '')
          .toString(),
      user: UserModel.fromJson((json['user'] as Map<String, dynamic>?) ?? json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}

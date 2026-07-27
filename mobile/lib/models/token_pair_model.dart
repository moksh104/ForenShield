import 'package:equatable/equatable.dart';

class TokenPairModel extends Equatable {
  final String accessToken;
  final String refreshToken;

  const TokenPairModel({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken];

  factory TokenPairModel.fromJson(Map<String, dynamic> json) {
    return TokenPairModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

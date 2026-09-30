import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/models/auth_response_model.dart';

void main() {
  group('AuthResponseModel Parsing Test against actual login.php response', () {
    test('parses exact JSON structure returned by PHP login.php', () {
      final jsonPayload = {
        'accessToken': 'header.payload.signature',
        'refreshToken': '9d1fd6f686111560e48f3d81b5e6b676ca3a24864c2d30f2b9152c9fc78382aa',
        'user': {
          'id': 5,
          'email': 'agent.test@forenshield.local',
          'displayName': 'Test Agent',
        },
      };

      final authResponse = AuthResponseModel.fromJson(jsonPayload);

      expect(authResponse.accessToken, equals('header.payload.signature'));
      expect(authResponse.refreshToken, equals('9d1fd6f686111560e48f3d81b5e6b676ca3a24864c2d30f2b9152c9fc78382aa'));
      expect(authResponse.user.id, equals('5'));
      expect(authResponse.user.email, equals('agent.test@forenshield.local'));
      expect(authResponse.user.displayName, equals('Test Agent'));
      expect(authResponse.user.rank, equals('Trainee'));
      expect(authResponse.user.totalXp, equals(0));
      expect(authResponse.user.currentStreak, equals(0));
    });

    test('parses when user id is string or int', () {
      final withStringId = {
        'accessToken': 'abc',
        'refreshToken': 'def',
        'user': {
          'id': '10',
          'email': 'test@test.com',
          'displayName': 'Agent 10',
        },
      };

      final resp = AuthResponseModel.fromJson(withStringId);
      expect(resp.user.id, equals('10'));
    });
  });
}

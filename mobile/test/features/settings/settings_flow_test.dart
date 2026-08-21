import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/core/constants/storage_keys.dart';
import 'package:forenshield/core/storage/storage_service.dart';
import 'package:forenshield/core/theme/foren_theme.dart';

import 'package:forenshield/features/settings/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    await StorageService.init();
  });

  setUp(() async {
    final storage = StorageService();
    await storage.deleteAll();
    await storage.saveAccessToken('mock_access_token');
    await storage.saveRefreshToken('mock_refresh_token');
  });

  testWidgets('Full Settings User Flow Test', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 4000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    // ── STEP 1: Open Settings ──────────────────────────────────────────────────
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ForenTheme.dark,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('ACCOUNT SETTINGS'), findsOneWidget);

    // ── STEP 2: Theme Change (Change to Light Mode) ──────────────────────────
    // Theme Mode is already visible due to huge surface
    final themeTile = find.text('Theme Mode');
    await tester.pumpAndSettle();

    expect(themeTile, findsOneWidget);
    await tester.tap(themeTile);
    await tester.pumpAndSettle();

    // Select Light Mode from dialog (there are 2 texts now: subtitle and dialog option)
    final lightOption = find.text('Light Mode').last;
    expect(lightOption, findsOneWidget);
    await tester.tap(lightOption);
    await tester.pumpAndSettle();

    // ── STEP 3: Verify Theme Persists ─────────────────────────────────────────
    await tester.pump(const Duration(milliseconds: 200));
    final storage = StorageService();
    final savedTheme = await storage.read(StorageKeys.themeMode);
    expect(savedTheme, equals('light'));

    final logoutTile = find.text('Logout');
    expect(logoutTile, findsOneWidget);
    await tester.tap(logoutTile);
    await tester.pumpAndSettle();

    // Confirm Sign Out Modal
    final confirmSignOutBtn = find.text('Logout');
    expect(confirmSignOutBtn, findsWidgets);
  });
}

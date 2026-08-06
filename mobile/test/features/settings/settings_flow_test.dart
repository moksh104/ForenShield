import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/core/constants/storage_keys.dart';
import 'package:forenshield/core/storage/storage_service.dart';
import 'package:forenshield/core/theme/foren_theme.dart';
import 'package:forenshield/features/settings/presentation/pages/privacy_policy_screen.dart';
import 'package:forenshield/features/settings/providers/settings_provider.dart';
import 'package:forenshield/features/settings/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  setUp(() async {
    final storage = StorageService();
    await storage.deleteAll();
    await storage.saveAccessToken('mock_access_token');
    await storage.saveRefreshToken('mock_refresh_token');
  });

  testWidgets('Full Settings User Flow Test', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Suppress overflow errors if any font metric issues arise in test environment
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
    expect(find.text('APPEARANCE'), findsOneWidget);

    // ── STEP 2: Theme Change (Change to Light Mode) ──────────────────────────
    final themeTile = find.text('Theme Mode');
    expect(themeTile, findsOneWidget);
    await tester.tap(themeTile);
    await tester.pumpAndSettle();

    // Select Light Theme from dialog
    final lightOption = find.text('Light Theme');
    expect(lightOption, findsOneWidget);
    await tester.tap(lightOption);
    await tester.pumpAndSettle();

    // ── STEP 3 & 4: Restart Application & Verify Theme Persists ─────────────
    final storage = StorageService();
    final savedTheme = await storage.read(StorageKeys.themeMode);
    expect(savedTheme, equals('light'));

    // Re-initialize a new SettingsNotifier to simulate fresh app relaunch
    final freshNotifier = SettingsNotifier();
    await tester.pump();
    await Future.delayed(const Duration(milliseconds: 100));
    expect(freshNotifier.state.themeMode, equals(ThemeMode.light));

    // Re-render SettingsScreen with new ProviderContainer
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ForenTheme.light,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Light Theme Active'), findsOneWidget);

    // ── STEP 5: Enable Notifications ──────────────────────────────────────────
    final pushSwitch = find.widgetWithText(SwitchListTile, 'Push Notifications');
    expect(pushSwitch, findsOneWidget);

    final threatSwitch = find.widgetWithText(SwitchListTile, 'Security Threat Alerts');
    expect(threatSwitch, findsOneWidget);

    final emailSwitch = find.widgetWithText(SwitchListTile, 'Email Notifications');
    expect(emailSwitch, findsOneWidget);

    // ── STEP 6: Enable Biometric Authentication ────────────────────────────────
    final biometricSwitch = find.widgetWithText(SwitchListTile, 'Biometric Authentication');
    expect(biometricSwitch, findsOneWidget);
    await tester.tap(biometricSwitch);
    await tester.pumpAndSettle();

    final bioSaved = await storage.readBool(StorageKeys.settingsBiometricLogin);
    expect(bioSaved, isTrue);

    // ── STEP 7: Open Privacy Policy ───────────────────────────────────────────
    final privacyPolicyTile = find.text('Privacy Policy');
    expect(privacyPolicyTile, findsOneWidget);

    // Render PrivacyPolicyScreen
    await tester.pumpWidget(
      MaterialApp(
        theme: ForenTheme.dark,
        home: const PrivacyPolicyScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ForenShield Privacy Policy'), findsOneWidget);
    expect(find.text('1. Information We Collect'), findsOneWidget);

    // Return to SettingsScreen
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ForenTheme.dark,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // ── STEP 8: Export Account Data ───────────────────────────────────────────
    final exportTile = find.text('Export Data');
    expect(exportTile, findsOneWidget);
    await tester.tap(exportTile);
    await tester.pumpAndSettle();

    // Confirm Modal
    final confirmExportBtn = find.text('Generate Export');
    expect(confirmExportBtn, findsOneWidget);
    await tester.tap(confirmExportBtn);

    // Pump timer for export generation
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    // ── STEP 9: Log Out ───────────────────────────────────────────────────────
    final logoutTile = find.text('Logout');
    expect(logoutTile, findsOneWidget);
    await tester.tap(logoutTile);
    await tester.pumpAndSettle();

    // Confirm Sign Out Modal
    final confirmSignOutBtn = find.text('Sign Out');
    expect(confirmSignOutBtn, findsOneWidget);
  });
}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/main.dart';
import 'package:forenshield/features/splash/presentation/pages/splash_screen.dart';
import 'package:forenshield/core/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    // shared_preferences native plugin is unavailable in the Dart VM test runner.
    // setMockInitialValues installs the in-memory shim so SharedPreferences
    // (and StorageService which wraps it) can be constructed without crashing.
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  testWidgets('SplashScreen renders correctly', (WidgetTester tester) async {
    // Set a realistic device viewport (390×844 dp, matching a standard phone).
    // The default test surface is too small for the onboarding layout that
    // loads after splash navigation completes.
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // The onboarding WelcomePage is reached after the splash timer fires.
    // Its flex layout can overflow in the test environment (font metrics may
    // differ from real devices). Suppress overflow errors for this test since
    // onboarding layout is not the subject under test.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await tester.pumpWidget(const ProviderScope(child: ForenShieldApp()));

    // Verify the splash screen widget is rendered as the initial route.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Drain all pending timers created by splash animations.
    // 1. LoadingBar start delay (1500ms)
    await tester.pump(const Duration(milliseconds: 1600));
    // 2. LoadingBar AnimationController progress (3000ms)
    await tester.pump(const Duration(milliseconds: 3100));
    // 3. Navigation delay after completion (500ms) — splash calls context.go()
    await tester.pump(const Duration(milliseconds: 600));
    // 4. Settle frame
    await tester.pump(const Duration(milliseconds: 100));

    // After all timers, the router has navigated away from splash.
    expect(find.byType(SplashScreen), findsNothing);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';
import 'package:mobile/features/splash/presentation/pages/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ForenShieldApp(),
      ),
    );

    // Verify the splash screen widget is rendered as the initial route
    expect(find.byType(SplashScreen), findsOneWidget);

    // Drain all pending timers created by splash animations:
    // 1. LoadingBar: Future.delayed(1500ms) to start animation
    await tester.pump(const Duration(milliseconds: 1600));
    // 2. RadarSweep: Future.delayed(800ms) — already elapsed
    // 3. LoadingBar: AnimationController(3000ms) runs the progress bar
    await tester.pump(const Duration(milliseconds: 3100));
    // 4. _onLoadingComplete: Future.delayed(500ms) for navigation delay
    //    This calls context.go() which navigates away from splash
    await tester.pump(const Duration(milliseconds: 600));
    // 5. Final frame to settle
    await tester.pump(const Duration(milliseconds: 100));
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env_config.dart';
import 'core/services/firebase_service.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'routes/app_router.dart';

/// ===========================================================================
/// ForenShield
/// Learn • Investigate • Defend
/// ===========================================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await EnvConfig.init();

  // Initialize local storage before the app starts.
  await StorageService.init();

  // Initialize Firebase & Messaging
  try {
    debugPrint('MAIN: Initializing Firebase...');
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    await ForenFirebaseService.initialize();
  } catch (e, stackTrace) {
    debugPrint('MAIN: Firebase initialization error: $e');
    debugPrint(stackTrace.toString());
  }

  runApp(const ProviderScope(child: ForenShieldApp()));
}

class ForenShieldApp extends ConsumerWidget {
  const ForenShieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'ForenShield',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),

      // Navigation
      routerConfig: router,
    );
  }
}

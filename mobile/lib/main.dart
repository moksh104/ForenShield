import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env_config.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'routes/app_router.dart';

/// ===========================================================================
/// ForenShield
/// Learn • Investigate • Defend
///
/// Frontend      : Flutter
/// State         : Riverpod
/// Navigation    : GoRouter
/// Backend       : PHP REST API
/// Authentication: JWT
/// Database      : PostgreSQL
/// Storage       : Cloudinary
/// Notifications : Firebase Cloud Messaging (Future)
/// ===========================================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await EnvConfig.init();

  // Initialize local storage before the app starts.
  await StorageService.init();

  runApp(
    const ProviderScope(
      child: ForenShieldApp(),
    ),
  );
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ForenShieldApp(),
    ),
  );
}

class ForenShieldApp extends StatelessWidget {
  const ForenShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ForenShield',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}

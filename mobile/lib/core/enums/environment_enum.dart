/// Defines the current execution environment for API resolution and logging.
enum AppEnvironment {
  development,
  staging,
  production;

  bool get isProduction => this == AppEnvironment.production;
  bool get isDevelopment => this == AppEnvironment.development;
}

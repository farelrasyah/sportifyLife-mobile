/// Environment configuration for SportifyLife app
/// DO NOT hardcode sensitive values here. Use environment variables in production.
class Environment {
  /// Environment type: development, staging, production
  static const String type = String.fromEnvironment(
    'ENV_TYPE',
    defaultValue: 'development',
  );

  /// Base URL for API
  /// Can be overridden via --dart-define=BASE_URL=http://your-ip:3000
  /// Example: flutter run --dart-define=BASE_URL=http://192.168.1.27:3000
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.1.27:3000',
  );

  /// API version prefix
  static const String apiVersion = 'v1';

  /// Full API URL
  static String get apiUrl => '$baseUrl/api/$apiVersion';

  /// Storage URL for media files
  static String get storageUrl => '$baseUrl/storage/';

  /// Request timeout in milliseconds
  static const int requestTimeout = 15000;

  /// Connection timeout in milliseconds
  static const int connectTimeout = 15000;

  /// Enable debug logging
  static bool get isDebugMode => type == 'development';

  /// Enable API request/response logging
  static bool get enableApiLogging => type == 'development';

  /// Validation constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const double minWeight = 20.0; // kg
  static const double maxWeight = 300.0; // kg
  static const int minHeight = 50; // cm
  static const int maxHeight = 250; // cm
  static const int minAge = 13; // years
  static const int maxAge = 120; // years

  /// Token expiry
  static const Duration verificationTokenExpiry = Duration(minutes: 1);

  /// Deep link scheme
  static const String appScheme = 'sportifylife';

  /// Storage keys
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userEmailKey = 'userEmail';
  static const String verificationExpiryKey = 'verificationExpiry';
  static const String userIdKey = 'userId';

  /// Print environment info (for debugging)
  static void printInfo() {
    if (isDebugMode) {
      print('═══════════════════════════════════════════════════');
      print('🌍 Environment: $type');
      print('🔗 Base URL: $baseUrl');
      print('📡 API URL: $apiUrl');
      print('📝 Debug Mode: $isDebugMode');
      print('═══════════════════════════════════════════════════');
    }
  }
}

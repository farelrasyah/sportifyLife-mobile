/// Global constants for SportifyLife app
/// Do not add / at the end of the url
class AppConstants {
  // API Base URLs - Uncomment yang akan digunakan
  // PENTING: Ganti IP_ADDRESS_LAPTOP_ANDA dengan IP address laptop Anda
  // Contoh: "http://192.168.1.100:3000"
  // Cara cek IP:
  // - Windows: buka CMD, ketik "ipconfig" -> lihat IPv4 Address
  // - Mac/Linux: buka Terminal, ketik "ifconfig" atau "ip addr show"

  static const String baseUrl = "http://192.168.1.7:3000"; // ✅ IP Laptop Anda
  // static const String baseUrl = "http://localhost:3000"; // Untuk emulator Android
  // static const String baseUrl = "http://10.0.2.2:3000"; // Untuk emulator Android (alternatif)
  // static const String baseUrl = "https://api.sportifylife.com";
  // static const String baseUrl = "https://staging-api.sportifylife.com";

  static const String apiUrl = "$baseUrl/api/v1";
  static const String storageUrl = "$baseUrl/storage/";

  // Timeouts
  static const int requestTimeout = 15000; // 15 seconds
  static const int connectTimeout = 15000;

  // Token Expiry
  static const Duration verificationTokenExpiry = Duration(minutes: 1);

  // Deep Link
  static const String appScheme = 'sportifylife';

  // Storage Keys
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userEmailKey = 'userEmail';
  static const String verificationExpiryKey = 'verificationExpiry';
  static const String userIdKey = 'userId';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const double minWeight = 20.0; // kg
  static const double maxWeight = 300.0; // kg
  static const int minHeight = 50; // cm
  static const int maxHeight = 250; // cm
}

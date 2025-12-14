import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

/// Secure storage helper for token and user data management
class StorageHelper {
  static final StorageHelper _instance = StorageHelper._internal();
  factory StorageHelper() => _instance;
  StorageHelper._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.refreshTokenKey);
  }

  // User Email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: AppConstants.userEmailKey, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: AppConstants.userEmailKey);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: AppConstants.userIdKey, value: userId);
  }

  // User First Name
  Future<void> saveUserFirstName(String firstName) async {
    await _storage.write(key: 'user_first_name', value: firstName);
  }

  Future<String?> getUserFirstName() async {
    return await _storage.read(key: 'user_first_name');
  }

  // User Last Name
  Future<void> saveUserLastName(String lastName) async {
    await _storage.write(key: 'user_last_name', value: lastName);
  }

  Future<String?> getUserLastName() async {
    return await _storage.read(key: 'user_last_name');
  }

  // Get Full Name
  Future<String> getUserFullName() async {
    final firstName = await getUserFirstName();
    final lastName = await getUserLastName();
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return 'User'; // Default
  }

  // Verification Expiry
  Future<void> saveVerificationExpiry(DateTime expiry) async {
    await _storage.write(
      key: AppConstants.verificationExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  Future<DateTime?> getVerificationExpiry() async {
    final expiryStr = await _storage.read(
      key: AppConstants.verificationExpiryKey,
    );
    if (expiryStr != null) {
      return DateTime.parse(expiryStr);
    }
    return null;
  }

  // Clear All
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Clear Auth Data (but preserve Remember Me)
  Future<void> clearAuthData() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userEmailKey);
    await _storage.delete(key: AppConstants.userIdKey);
    await _storage.delete(key: 'user_first_name');
    await _storage.delete(key: 'user_last_name');
    await _storage.delete(key: AppConstants.verificationExpiryKey);
  }

  // Clear Verification Data
  Future<void> clearVerificationData() async {
    await _storage.delete(key: AppConstants.verificationExpiryKey);
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Remember Me Credentials
  Future<void> saveRememberMeEmail(String email) async {
    await _storage.write(key: 'remember_me_email', value: email);
  }

  Future<String?> getRememberMeEmail() async {
    return await _storage.read(key: 'remember_me_email');
  }

  Future<void> saveRememberMePassword(String password) async {
    await _storage.write(key: 'remember_me_password', value: password);
  }

  Future<String?> getRememberMePassword() async {
    return await _storage.read(key: 'remember_me_password');
  }

  Future<void> clearRememberMeCredentials() async {
    await _storage.delete(key: 'remember_me_email');
    await _storage.delete(key: 'remember_me_password');
  }
}

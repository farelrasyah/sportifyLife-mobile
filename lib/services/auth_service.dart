import '../core/result.dart';
import '../data/models/auth_response_model.dart';
import '../data/models/user_model.dart';
import '../data/models/password_reset_model.dart';
import '../services/http_service.dart';
import '../utils/storage_helper.dart';

/// Authentication Service
/// Handles all authentication-related operations with clean architecture
class AuthService {
  final HttpService _httpService;
  final StorageHelper _storage;

  AuthService({HttpService? httpService, StorageHelper? storage})
    : _httpService = httpService ?? HttpService(),
      _storage = storage ?? StorageHelper();

  /// Register new user
  /// Returns AuthResponse with tokens and user data
  Future<Result<AuthResponseModel>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    // Client-side validation
    if (email.isEmpty || !_isValidEmail(email)) {
      return Failure(
        ServiceError.validation('Please enter a valid email address'),
      );
    }

    if (password.length < 6) {
      return Failure(
        ServiceError.validation('Password must be at least 6 characters'),
      );
    }

    if (password != confirmPassword) {
      return Failure(ServiceError.validation('Passwords do not match'));
    }

    if (firstName.isEmpty || lastName.isEmpty) {
      return Failure(
        ServiceError.validation('First name and last name are required'),
      );
    }

    // Make API request
    final result = await _httpService.post<AuthResponseModel>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'firstName': firstName,
        'lastName': lastName,
      },
      fromJson: (json) =>
          AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );

    // Save tokens if successful
    if (result.isSuccess) {
      final authResponse = result.dataOrNull!;
      await _saveAuthData(authResponse);
    }

    return result;
  }

  /// Login user
  /// Returns AuthResponse with tokens and user data
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    // Client-side validation
    if (email.isEmpty || !_isValidEmail(email)) {
      return Failure(
        ServiceError.validation('Please enter a valid email address'),
      );
    }

    if (password.isEmpty) {
      return Failure(ServiceError.validation('Password is required'));
    }

    // Make API request
    final result = await _httpService.post<AuthResponseModel>(
      '/auth/login',
      data: {'email': email, 'password': password},
      fromJson: (json) =>
          AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );

    // Save tokens if successful
    if (result.isSuccess) {
      final authResponse = result.dataOrNull!;
      await _saveAuthData(authResponse);
    }

    return result;
  }

  /// Get current authenticated user
  /// Returns user data from backend
  Future<Result<UserModel>> getCurrentUser() async {
    return await _httpService.get<UserModel>(
      '/auth/me',
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Logout user
  /// Clears tokens and user data from storage
  Future<Result<void>> logout() async {
    try {
      // Call backend to invalidate token
      await _httpService.post<void>('/auth/logout', fromJson: (_) => null);
    } catch (_) {
      // Continue with local logout even if backend call fails
    }

    // Clear local storage
    await _storage.clearAuthData();
    await _httpService.clearAuth();

    return const Success(null);
  }

  /// Check if user is authenticated
  /// Returns true if valid access token exists
  Future<bool> isAuthenticated() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Save authentication data to secure storage
  Future<void> _saveAuthData(AuthResponseModel authResponse) async {
    await _storage.saveAccessToken(authResponse.accessToken);
    await _storage.saveRefreshToken(authResponse.refreshToken);
    await _storage.saveUserEmail(authResponse.user.email);
    await _storage.saveUserId(authResponse.user.id);
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Forgot password
  Future<Result<String>> forgotPassword(String email) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      return Failure(
        ServiceError.validation('Please enter a valid email address'),
      );
    }

    final result = await _httpService.post<Map<String, dynamic>>(
      '/auth/forgot-password',
      data: {'email': email},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.map(
      (data) => data['message'] as String? ?? 'Password reset email sent',
    );
  }

  /// Change password
  Future<Result<String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword.length < 6) {
      return Failure(
        ServiceError.validation('New password must be at least 6 characters'),
      );
    }

    if (newPassword != confirmPassword) {
      return Failure(ServiceError.validation('New passwords do not match'));
    }

    final result = await _httpService.post<Map<String, dynamic>>(
      '/auth/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.map(
      (data) => data['message'] as String? ?? 'Password changed successfully',
    );
  }

  /// Request password reset OTP
  /// Sends OTP to user's email for password reset
  Future<Result<PasswordResetResponseModel>> requestPasswordResetOtp({
    required String email,
  }) async {
    // Client-side validation
    if (email.isEmpty || !_isValidEmail(email)) {
      return Failure(
        ServiceError.validation('Please enter a valid email address'),
      );
    }

    // Make API request
    final result = await _httpService.post<PasswordResetResponseModel>(
      '/auth/forgot-password',
      data: {'email': email},
      fromJson: (json) =>
          PasswordResetResponseModel.fromJson(json as Map<String, dynamic>),
    );

    return result;
  }

  /// Verify OTP for password reset
  /// Validates the OTP sent to user's email
  Future<Result<OtpVerificationResponseModel>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    // Client-side validation
    if (email.isEmpty || !_isValidEmail(email)) {
      return Failure(
        ServiceError.validation('Please enter a valid email address'),
      );
    }

    if (otp.isEmpty || otp.length != 6) {
      return Failure(
        ServiceError.validation('Please enter a valid 6-digit OTP code'),
      );
    }

    // Make API request
    final result = await _httpService.post<OtpVerificationResponseModel>(
      '/auth/verify-otp',
      data: {'email': email, 'otp': otp},
      fromJson: (json) =>
          OtpVerificationResponseModel.fromJson(json as Map<String, dynamic>),
    );

    return result;
  }

  /// Reset password with OTP
  /// Changes user's password using verified OTP
  Future<Result<PasswordResetResponseModel>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    // Client-side validation
    if (email.isEmpty || !_isValidEmail(email)) {
      return Failure(
        ServiceError.validation('Please enter a valid email address'),
      );
    }

    if (otp.isEmpty || otp.length != 6) {
      return Failure(
        ServiceError.validation('Please enter a valid 6-digit OTP code'),
      );
    }

    if (newPassword.length < 8) {
      return Failure(
        ServiceError.validation('Password must be at least 8 characters'),
      );
    }

    // Password strength validation (according to backend requirements)
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,128}$',
    );
    if (!passwordRegex.hasMatch(newPassword)) {
      return Failure(
        ServiceError.validation(
          'Password must contain at least:\n'
          '• 8 characters\n'
          '• 1 lowercase letter (a-z)\n'
          '• 1 uppercase letter (A-Z)\n'
          '• 1 number (0-9)\n'
          '• 1 special character (@\$!%*?&)',
        ),
      );
    }

    if (newPassword != confirmNewPassword) {
      return Failure(ServiceError.validation('Passwords do not match'));
    }

    // Make API request
    final result = await _httpService.post<PasswordResetResponseModel>(
      '/auth/reset-password',
      data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
      fromJson: (json) =>
          PasswordResetResponseModel.fromJson(json as Map<String, dynamic>),
    );

    return result;
  }
}

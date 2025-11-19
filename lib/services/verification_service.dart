import 'dart:async';
import '../core/result.dart';
import '../services/http_service.dart';
import '../services/auth_service.dart';
import '../data/models/userModel.dart';
import '../config/environment.dart';

/// Email Verification Service
/// Handles email verification logic with automatic checking
class VerificationService {
  final HttpService _httpService;
  final AuthService _authService;

  VerificationService({HttpService? httpService, AuthService? authService})
    : _httpService = httpService ?? HttpService(),
      _authService = authService ?? AuthService();

  /// Verify email with token from URL
  /// Called when user clicks verification link
  Future<Result<String>> verifyEmail(String token) async {
    if (token.isEmpty) {
      return Failure(ServiceError.validation('Invalid verification token'));
    }

    final result = await _httpService.get<Map<String, dynamic>>(
      '/auth/verify-email',
      queryParameters: {'token': token},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.map(
      (data) => data['message'] as String? ?? 'Email verified successfully',
    );
  }

  /// Resend verification email
  /// Sends a new verification link to user's email
  Future<Result<String>> resendVerification(String email) async {
    if (email.isEmpty) {
      return Failure(ServiceError.validation('Email address is required'));
    }

    final result = await _httpService.post<Map<String, dynamic>>(
      '/auth/resend-verification',
      data: {'email': email},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.map(
      (data) =>
          data['message'] as String? ?? 'Verification email sent successfully',
    );
  }

  /// Check if email is verified
  /// Fetches current user data and checks isVerified field
  Future<Result<VerificationStatus>> checkVerificationStatus() async {
    final result = await _authService.getCurrentUser();

    return result.map((user) {
      if (user.isVerified) {
        return VerificationStatus.verified(user);
      } else {
        return VerificationStatus.unverified(user);
      }
    });
  }

  /// Auto-check verification status with polling
  /// Useful for checking if user verified email in another tab/device
  /// Returns stream that emits verification status updates
  Stream<Result<VerificationStatus>> autoCheckVerification({
    Duration interval = const Duration(seconds: 5),
    int maxAttempts = 20, // 20 attempts * 5 seconds = 100 seconds total
  }) async* {
    int attempts = 0;

    while (attempts < maxAttempts) {
      attempts++;

      // Check verification status
      final result = await checkVerificationStatus();

      yield result;

      // If verified, stop checking
      if (result.isSuccess && result.dataOrNull?.isVerified == true) {
        break;
      }

      // Wait before next check
      if (attempts < maxAttempts) {
        await Future.delayed(interval);
      }
    }
  }

  /// Calculate verification expiry time
  DateTime calculateExpiry() {
    return DateTime.now().add(Environment.verificationTokenExpiry);
  }

  /// Check if verification is expired
  bool isExpired(DateTime expiryTime) {
    return DateTime.now().isAfter(expiryTime);
  }
}

/// Verification Status
/// Represents the current state of email verification
class VerificationStatus {
  final bool isVerified;
  final UserModel user;
  final String? message;

  const VerificationStatus({
    required this.isVerified,
    required this.user,
    this.message,
  });

  factory VerificationStatus.verified(UserModel user) {
    return VerificationStatus(
      isVerified: true,
      user: user,
      message: 'Email verified successfully',
    );
  }

  factory VerificationStatus.unverified(UserModel user) {
    return VerificationStatus(
      isVerified: false,
      user: user,
      message: 'Email not yet verified',
    );
  }
}

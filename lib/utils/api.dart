import 'constants.dart';

/// API Exception for custom error handling
class ApiException implements Exception {
  final String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

/// API Endpoints
class Api {
  // Auth Endpoints
  static String login = "${AppConstants.apiUrl}/auth/login";
  static String register = "${AppConstants.apiUrl}/auth/register";
  static String logout = "${AppConstants.apiUrl}/auth/logout";
  static String verifyEmail = "${AppConstants.apiUrl}/auth/verify-email";
  static String resendVerification =
      "${AppConstants.apiUrl}/auth/resend-verification";
  static String currentUser = "${AppConstants.apiUrl}/auth/me";

  // Password Endpoints
  static String forgotPassword = "${AppConstants.apiUrl}/auth/forgot-password";
  static String resetPassword = "${AppConstants.apiUrl}/auth/reset-password";
  static String changePassword = "${AppConstants.apiUrl}/auth/change-password";

  // Profile Endpoints (Auth-based)
  static String completeProfile =
      "${AppConstants.apiUrl}/auth/complete-profile";
  static String getUserDetails = "${AppConstants.apiUrl}/user/details";
  static String updateUserDetails = "${AppConstants.apiUrl}/user/details";
  static String updateProfile = "${AppConstants.apiUrl}/user/profile";
  static String uploadProfilePhoto =
      "${AppConstants.apiUrl}/user/profile-photo";
}

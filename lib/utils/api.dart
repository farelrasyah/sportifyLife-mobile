import 'constants.dart';

/// API Exception for custom error handling
class ApiException implements Exception {
  final String errorMessage;

  ApiException(this.errorMessage);

  String get message => errorMessage;

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

  // Password Reset Endpoints
  static String forgotPassword = "${AppConstants.apiUrl}/auth/forgot-password";
  static String verifyOtp = "${AppConstants.apiUrl}/auth/verify-otp";
  static String resetPassword = "${AppConstants.apiUrl}/auth/reset-password";
  static String changePassword = "${AppConstants.apiUrl}/auth/change-password";
  static String completeProfile =
      "${AppConstants.apiUrl}/auth/complete-profile";
  static String postGoal = "${AppConstants.apiUrl}/users/goals";
  static String getUserDetails = "${AppConstants.apiUrl}/user/details";
  static String updateUserDetails = "${AppConstants.apiUrl}/user/details";
  static String updateProfile = "${AppConstants.apiUrl}/user/profile";
  static String uploadProfilePhoto =
      "${AppConstants.apiUrl}/user/profile-photo";

  // Sleep Endpoints
  static String sleepSchedules = "${AppConstants.apiUrl}/sleep/schedule";
  static String sleepScheduleById =
      "${AppConstants.apiUrl}/sleep/schedule"; // + /:id
  static String createSleepSchedule = "${AppConstants.apiUrl}/sleep/schedule";
  static String updateSleepSchedule =
      "${AppConstants.apiUrl}/sleep/schedule"; // + /:id
  static String deleteSleepSchedule =
      "${AppConstants.apiUrl}/sleep/schedule"; // + /:id
  static String sleepCalendar =
      "${AppConstants.apiUrl}/sleep/schedule/calendar";
  static String sleepDailySummary =
      "${AppConstants.apiUrl}/health/sleep/daily-summary";

  // Sleep API Helper Methods
  static String getSleepScheduleByIdUrl(String id) => "$sleepScheduleById/$id";
  static String updateSleepScheduleUrl(String id) => "$updateSleepSchedule/$id";
  static String deleteSleepScheduleUrl(String id) => "$deleteSleepSchedule/$id";
}

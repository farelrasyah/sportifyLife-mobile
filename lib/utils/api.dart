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

  // ============================================================
  // EXERCISES ENDPOINTS
  // ============================================================

  /// Base exercises endpoint
  static String exercises = "${AppConstants.apiUrl}/exercises";

  /// Get exercise by ID
  static String getExerciseById(String id) => "$exercises/$id";

  /// Get exercise types for filtering
  static String exerciseTypes = "$exercises/types";

  /// Get body parts for filtering
  static String exerciseBodyParts = "$exercises/body-parts";

  /// Get equipment options for filtering
  static String exerciseEquipments = "$exercises/equipments";

  /// Get target muscles for filtering
  static String exerciseTargetMuscles = "$exercises/target-muscles";

  // ============================================================
  // CUSTOM WORKOUT PLANS ENDPOINTS
  // ============================================================

  /// Base custom workout plans endpoint
  static String customWorkoutPlans =
      "${AppConstants.apiUrl}/workouts/custom/plans";

  /// Get custom workout plan by ID
  static String getCustomWorkoutPlanById(String id) =>
      "$customWorkoutPlans/$id";

  /// Update custom workout plan by ID
  static String updateCustomWorkoutPlan(String id) => "$customWorkoutPlans/$id";

  /// Delete custom workout plan by ID
  static String deleteCustomWorkoutPlan(String id) => "$customWorkoutPlans/$id";

  // ============================================================
  // WORKOUT SCHEDULES ENDPOINTS
  // ============================================================

  /// Base workout schedules endpoint
  static String workoutSchedules =
      "${AppConstants.apiUrl}/workouts/custom/schedules";

  /// Get upcoming workout schedules
  static String upcomingWorkoutSchedules = "$workoutSchedules/upcoming";

  /// Get workout schedule by ID
  static String getWorkoutScheduleById(String id) => "$workoutSchedules/$id";

  /// Update workout schedule by ID
  static String updateWorkoutSchedule(String id) => "$workoutSchedules/$id";

  /// Delete workout schedule by ID
  static String deleteWorkoutSchedule(String id) => "$workoutSchedules/$id";

  // ============================================================
  // WORKOUT SESSIONS ENDPOINTS
  // ============================================================

  /// Base workout sessions endpoint
  static String workoutSessions =
      "${AppConstants.apiUrl}/workouts/custom/sessions";

  /// Start a new workout session
  static String startWorkoutSession = "$workoutSessions/start";

  /// Get active workout session
  static String activeWorkoutSession = "$workoutSessions/active";

  /// Update exercise progress in session
  static String updateExerciseProgress(String sessionId) =>
      "$workoutSessions/$sessionId/exercise-progress";

  /// Complete workout session
  static String completeWorkoutSession(String sessionId) =>
      "$workoutSessions/$sessionId/complete";

  /// Pause workout session
  static String pauseWorkoutSession(String sessionId) =>
      "$workoutSessions/$sessionId/pause";

  /// Resume workout session
  static String resumeWorkoutSession(String sessionId) =>
      "$workoutSessions/$sessionId/resume";

  // ============================================================
  // WORKOUT HISTORY & STATISTICS ENDPOINTS
  // ============================================================

  /// Base workout history endpoint
  static String workoutHistory =
      "${AppConstants.apiUrl}/workouts/custom/history";

  /// Get workout session detail by ID
  static String getWorkoutHistoryById(String sessionId) =>
      "$workoutHistory/$sessionId";

  /// Get workout statistics
  static String workoutStatistics =
      "${AppConstants.apiUrl}/workouts/custom/statistics";

  /// Get weekly workout statistics
  static String weeklyWorkoutStatistics = "$workoutStatistics/weekly";

  /// Get monthly workout statistics
  static String monthlyWorkoutStatistics = "$workoutStatistics/monthly";
}

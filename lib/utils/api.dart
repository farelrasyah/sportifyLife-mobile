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
  // WORKOUTS ENDPOINTS (NEW API)
  // ============================================================

  /// Base workouts endpoint - GET /workouts
  static String workouts = "${AppConstants.apiUrl}/workouts";

  /// Get workout by ID - GET /workouts/:id
  static String getWorkoutById(String id) => "$workouts/$id";

  // ============================================================
  // WORKOUT SESSIONS ENDPOINTS (NEW API)
  // ============================================================

  /// Base workout sessions endpoint
  static String workoutSessions = "${AppConstants.apiUrl}/workout-sessions";

  /// Start a new workout session - POST /workout-sessions/start
  static String startWorkoutSession = "$workoutSessions/start";

  /// Get active workout session - GET /workout-sessions/active
  static String activeWorkoutSession = "$workoutSessions/active";

  /// Complete workout session - PATCH /workout-sessions/:id/complete
  static String completeWorkoutSession(String sessionId) =>
      "$workoutSessions/$sessionId/complete";

  /// Pause workout session - PATCH /workout-sessions/:id/pause
  static String pauseWorkoutSession(String sessionId) =>
      "$workoutSessions/$sessionId/pause";

  /// Resume workout session - PATCH /workout-sessions/:id/resume
  static String resumeWorkoutSession(String sessionId) =>
      "$workoutSessions/$sessionId/resume";

  /// Update exercise progress in session - PATCH /workout-sessions/:id/exercise-progress
  static String updateExerciseProgress(String sessionId) =>
      "$workoutSessions/$sessionId/exercise-progress";

  /// Get workout history - GET /workout-sessions/history
  static String workoutHistory = "$workoutSessions/history";

  /// Get workout session detail by ID - GET /workout-sessions/:id
  static String getWorkoutHistoryById(String sessionId) =>
      "$workoutSessions/$sessionId";

  /// Get weekly progress - GET /workout-sessions/weekly-progress
  static String weeklyProgress = "$workoutSessions/weekly-progress";

  // ============================================================
  // WORKOUT SCHEDULES ENDPOINTS (NEW API)
  // ============================================================

  /// Base workout schedules endpoint - GET /workout-schedules
  static String workoutSchedules = "${AppConstants.apiUrl}/workout-schedules";

  /// Get upcoming schedules - GET /workout-schedules/upcoming
  static String upcomingWorkoutSchedules = "$workoutSchedules/upcoming";

  /// Get workout schedule by ID - GET /workout-schedules/:id
  static String getWorkoutScheduleById(String id) => "$workoutSchedules/$id";

  /// Update workout schedule - PATCH /workout-schedules/:id
  static String updateWorkoutSchedule(String id) => "$workoutSchedules/$id";

  /// Delete workout schedule - DELETE /workout-schedules/:id
  static String deleteWorkoutSchedule(String id) => "$workoutSchedules/$id";

  // ============================================================
  // LEGACY ENDPOINTS (untuk backward compatibility)
  // ============================================================

  /// Base custom workout plans endpoint (legacy)
  static String customWorkoutPlans =
      "${AppConstants.apiUrl}/workouts/custom/plans";

  /// Get custom workout plan by ID (legacy)
  static String getCustomWorkoutPlanById(String id) =>
      "$customWorkoutPlans/$id";

  /// Update custom workout plan by ID (legacy)
  static String updateCustomWorkoutPlan(String id) => "$customWorkoutPlans/$id";

  /// Delete custom workout plan by ID (legacy)
  static String deleteCustomWorkoutPlan(String id) => "$customWorkoutPlans/$id";

  /// Toggle schedule reminder (legacy)
  static String toggleScheduleReminder(String id) =>
      "$workoutSchedules/$id/toggle-reminder";

  /// Get workout statistics (legacy)
  static String workoutStatistics =
      "${AppConstants.apiUrl}/workouts/statistics";

  /// Get weekly workout statistics (legacy - use weeklyProgress instead)
  static String weeklyWorkoutStatistics = weeklyProgress;

  /// Get monthly workout statistics (legacy)
  static String monthlyWorkoutStatistics = "$workoutStatistics/monthly";
}

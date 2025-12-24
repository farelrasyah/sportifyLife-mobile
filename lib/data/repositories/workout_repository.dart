import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/workout_plan_model.dart';
import '../models/workout_session_model.dart';
import '../models/workout_statistics_model.dart';
import '../models/api_response_model.dart';
import '../../utils/api.dart';
import '../../utils/api_client.dart';

/// Workout Repository for API calls
class WorkoutRepository {
  final ApiClient _apiClient = ApiClient();

  // ============================================================
  // CUSTOM WORKOUT PLANS
  // ============================================================

  /// Create a new custom workout plan
  Future<CustomWorkoutPlanModel> createWorkoutPlan(
    CustomWorkoutPlanModel plan,
  ) async {
    try {
      debugPrint('Creating workout plan: ${plan.name}');

      final response = await _apiClient.dio.post(
        Api.customWorkoutPlans,
        data: plan.toCreateJson(),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to create workout plan');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return CustomWorkoutPlanModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return CustomWorkoutPlanModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error creating workout plan: $e');
      rethrow;
    }
  }

  /// Get all custom workout plans
  Future<List<CustomWorkoutPlanModel>> getWorkoutPlans() async {
    try {
      debugPrint('Fetching workout plans');

      final response = await _apiClient.dio.get(Api.customWorkoutPlans);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load workout plans');
      }

      final responseData = apiResponse.data!;
      List<dynamic> plansList;

      if (responseData.containsKey('data') && responseData['data'] is List) {
        plansList = responseData['data'] as List<dynamic>;
      } else {
        plansList = [];
      }

      return plansList
          .map(
            (e) => CustomWorkoutPlanModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout plans: $e');
      rethrow;
    }
  }

  /// Get workout plan by ID
  Future<CustomWorkoutPlanModel> getWorkoutPlanById(String id) async {
    try {
      debugPrint('Fetching workout plan with ID: $id');

      final response = await _apiClient.dio.get(
        Api.getCustomWorkoutPlanById(id),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load workout plan');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return CustomWorkoutPlanModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return CustomWorkoutPlanModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout plan: $e');
      rethrow;
    }
  }

  /// Update workout plan
  Future<CustomWorkoutPlanModel> updateWorkoutPlan(
    String id,
    CustomWorkoutPlanModel plan,
  ) async {
    try {
      debugPrint('Updating workout plan: $id');

      final response = await _apiClient.dio.patch(
        Api.updateCustomWorkoutPlan(id),
        data: plan.toCreateJson(),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to update workout plan');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return CustomWorkoutPlanModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return CustomWorkoutPlanModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error updating workout plan: $e');
      rethrow;
    }
  }

  /// Delete workout plan
  Future<void> deleteWorkoutPlan(String id) async {
    try {
      debugPrint('Deleting workout plan: $id');

      final response = await _apiClient.dio.delete(
        Api.deleteCustomWorkoutPlan(id),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success) {
        throw ApiException('Failed to delete workout plan');
      }
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error deleting workout plan: $e');
      rethrow;
    }
  }

  // ============================================================
  // WORKOUT SCHEDULES
  // ============================================================

  /// Create a new workout schedule
  Future<WorkoutScheduleModel> createWorkoutSchedule(
    WorkoutScheduleModel schedule,
  ) async {
    try {
      debugPrint('Creating workout schedule');

      final response = await _apiClient.dio.post(
        Api.workoutSchedules,
        data: schedule.toCreateJson(),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to create workout schedule');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutScheduleModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutScheduleModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error creating workout schedule: $e');
      rethrow;
    }
  }

  /// Get today's workout schedules
  Future<List<WorkoutScheduleModel>> getTodaySchedules() async {
    try {
      debugPrint('Fetching today schedules');

      // Fetch all schedules then filter client-side
      final response = await _apiClient.dio.get(Api.workoutSchedules);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load schedules');
      }

      final responseData = apiResponse.data!;
      List<dynamic> schedulesList;

      if (responseData.containsKey('data') && responseData['data'] is List) {
        schedulesList = responseData['data'] as List<dynamic>;
      } else {
        schedulesList = [];
      }

      final allSchedules = schedulesList
          .map((e) => WorkoutScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Filter for today only
      final today = DateTime.now();
      return allSchedules.where((schedule) {
        if (schedule.scheduledDateTime == null) return false;
        final scheduleDate = schedule.scheduledDateTime!;
        return scheduleDate.year == today.year &&
            scheduleDate.month == today.month &&
            scheduleDate.day == today.day;
      }).toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching today schedules: $e');
      rethrow;
    }
  }

  /// Get upcoming workout schedules
  Future<List<WorkoutScheduleModel>> getUpcomingSchedules() async {
    try {
      debugPrint('Fetching upcoming schedules');

      // Fetch all schedules then filter client-side
      final response = await _apiClient.dio.get(Api.workoutSchedules);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load schedules');
      }

      final responseData = apiResponse.data!;
      List<dynamic> schedulesList;

      if (responseData.containsKey('data') && responseData['data'] is List) {
        schedulesList = responseData['data'] as List<dynamic>;
      } else {
        schedulesList = [];
      }

      final allSchedules = schedulesList
          .map((e) => WorkoutScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Filter for upcoming only (after today)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return allSchedules.where((schedule) {
        if (schedule.scheduledDateTime == null) return false;
        final scheduleDate = DateTime(
          schedule.scheduledDateTime!.year,
          schedule.scheduledDateTime!.month,
          schedule.scheduledDateTime!.day,
        );
        return scheduleDate.isAfter(today);
      }).toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching upcoming schedules: $e');
      rethrow;
    }
  }

  /// Toggle schedule reminder
  Future<void> toggleScheduleReminder(String id, bool isEnabled) async {
    try {
      debugPrint('Toggling reminder for schedule: $id');

      final response = await _apiClient.dio.patch(
        Api.toggleScheduleReminder(id),
        data: {'isReminderEnabled': isEnabled},
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success) {
        throw ApiException('Failed to toggle reminder');
      }
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error toggling reminder: $e');
      rethrow;
    }
  }

  /// Delete workout schedule
  Future<void> deleteWorkoutSchedule(String id) async {
    try {
      debugPrint('Deleting workout schedule: $id');

      final response = await _apiClient.dio.delete(
        Api.deleteWorkoutSchedule(id),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success) {
        throw ApiException('Failed to delete workout schedule');
      }
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error deleting workout schedule: $e');
      rethrow;
    }
  }

  // ============================================================
  // WORKOUT SESSIONS
  // ============================================================

  /// Start a new workout session
  Future<WorkoutSessionModel> startWorkoutSession(
    StartWorkoutSessionRequest request,
  ) async {
    try {
      debugPrint('Starting workout session');

      final response = await _apiClient.dio.post(
        Api.startWorkoutSession,
        data: request.toJson(),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to start workout session');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutSessionModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutSessionModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error starting workout session: $e');
      rethrow;
    }
  }

  /// Get active workout session
  Future<WorkoutSessionModel?> getActiveSession() async {
    try {
      debugPrint('Fetching active workout session');

      final response = await _apiClient.dio.get(Api.activeWorkoutSession);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        return null;
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutSessionModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      if (responseData.isEmpty) {
        return null;
      }

      return WorkoutSessionModel.fromJson(responseData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching active session: $e');
      rethrow;
    }
  }

  /// Update exercise progress in session
  Future<ExerciseProgressModel> updateExerciseProgress(
    String sessionId,
    ExerciseProgressModel progress,
  ) async {
    try {
      debugPrint('Updating exercise progress for session: $sessionId');

      final response = await _apiClient.dio.patch(
        Api.updateExerciseProgress(sessionId),
        data: progress.toUpdateJson(),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to update exercise progress');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return ExerciseProgressModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return ExerciseProgressModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error updating exercise progress: $e');
      rethrow;
    }
  }

  /// Complete workout session
  Future<WorkoutSessionModel> completeWorkoutSession(
    String sessionId,
    CompleteWorkoutSessionRequest request,
  ) async {
    try {
      debugPrint('Completing workout session: $sessionId');

      final response = await _apiClient.dio.patch(
        Api.completeWorkoutSession(sessionId),
        data: request.toJson(),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to complete workout session');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutSessionModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutSessionModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error completing workout session: $e');
      rethrow;
    }
  }

  /// Pause workout session
  Future<WorkoutSessionModel> pauseWorkoutSession(String sessionId) async {
    try {
      debugPrint('Pausing workout session: $sessionId');

      final response = await _apiClient.dio.patch(
        Api.pauseWorkoutSession(sessionId),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to pause workout session');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutSessionModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutSessionModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error pausing workout session: $e');
      rethrow;
    }
  }

  /// Resume workout session
  Future<WorkoutSessionModel> resumeWorkoutSession(String sessionId) async {
    try {
      debugPrint('Resuming workout session: $sessionId');

      final response = await _apiClient.dio.patch(
        Api.resumeWorkoutSession(sessionId),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to resume workout session');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutSessionModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutSessionModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error resuming workout session: $e');
      rethrow;
    }
  }

  // ============================================================
  // WORKOUT HISTORY & STATISTICS
  // ============================================================

  /// Get workout history
  Future<WorkoutHistoryResponseModel> getWorkoutHistory({
    int page = 1,
    int limit = 20,
    String? startDate,
    String? endDate,
    String? workoutType,
    bool? completedOnly,
  }) async {
    try {
      debugPrint('Fetching workout history');

      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (workoutType != null) queryParams['workoutType'] = workoutType;
      if (completedOnly != null) queryParams['completedOnly'] = completedOnly;

      final response = await _apiClient.dio.get(
        Api.workoutHistory,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load workout history');
      }

      return WorkoutHistoryResponseModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout history: $e');
      rethrow;
    }
  }

  /// Get workout session detail by ID
  Future<WorkoutSessionModel> getWorkoutHistoryById(String sessionId) async {
    try {
      debugPrint('Fetching workout history detail: $sessionId');

      final response = await _apiClient.dio.get(
        Api.getWorkoutHistoryById(sessionId),
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load workout history detail');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutSessionModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutSessionModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout history detail: $e');
      rethrow;
    }
  }

  /// Get workout statistics
  Future<WorkoutStatisticsModel> getWorkoutStatistics() async {
    try {
      debugPrint('Fetching workout statistics');

      final response = await _apiClient.dio.get(Api.workoutStatistics);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load workout statistics');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WorkoutStatisticsModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WorkoutStatisticsModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout statistics: $e');
      rethrow;
    }
  }

  /// Get weekly workout statistics
  Future<WeeklyStatisticsModel> getWeeklyStatistics() async {
    try {
      debugPrint('Fetching weekly statistics');

      // Use correct endpoint: /workouts/sessions/weekly-progress
      final response = await _apiClient.dio.get(Api.weeklyProgress);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load weekly statistics');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return WeeklyStatisticsModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return WeeklyStatisticsModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching weekly statistics: $e');
      rethrow;
    }
  }

  /// Get monthly workout statistics
  Future<MonthlyStatisticsModel> getMonthlyStatistics({
    int? year,
    int? month,
  }) async {
    try {
      debugPrint('Fetching monthly statistics');

      final queryParams = <String, dynamic>{};
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;

      final response = await _apiClient.dio.get(
        Api.monthlyWorkoutStatistics,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load monthly statistics');
      }

      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return MonthlyStatisticsModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return MonthlyStatisticsModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching monthly statistics: $e');
      rethrow;
    }
  }

  /// Handle Dio errors
  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? 'An error occurred';
      }
      return 'Error: ${e.response?.statusCode}';
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.message ?? 'An unexpected error occurred';
    }
  }
}

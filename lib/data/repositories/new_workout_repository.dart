import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';
import '../models/api_response_model.dart';
import '../../utils/api.dart';
import '../../utils/api_client.dart';

/// New Workout Repository - sesuai API dokumentasi baru
/// Endpoint: /workouts, /workout-sessions, /workout-schedules
class NewWorkoutRepository {
  final ApiClient _apiClient = ApiClient();

  // ============================================================
  // WORKOUTS (GET /workouts)
  // ============================================================

  /// Get all workouts with filters and pagination
  /// GET /workouts?page=1&limit=10&level=beginner&category=fullbody&search=
  Future<PaginatedWorkoutsModel> getWorkouts({
    int page = 1,
    int limit = 10,
    String? level,
    String? category,
    String? search,
  }) async {
    try {
      debugPrint(
        'Fetching workouts: page=$page, limit=$limit, level=$level, category=$category',
      );

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (level != null && level.isNotEmpty) 'level': level,
        if (category != null && category.isNotEmpty) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiClient.dio.get(
        Api.workouts,
        queryParameters: queryParams,
      );

      if (response.data is Map<String, dynamic>) {
        return PaginatedWorkoutsModel.fromJson(response.data);
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workouts: $e');
      rethrow;
    }
  }

  /// Get workout detail by ID
  /// GET /workouts/:id
  Future<WorkoutDetailModel> getWorkoutDetail(String workoutId) async {
    try {
      debugPrint('Fetching workout detail: $workoutId');

      final response = await _apiClient.dio.get(Api.getWorkoutById(workoutId));

      if (response.data is Map<String, dynamic>) {
        return WorkoutDetailModel.fromJson(response.data);
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException('Workout not found');
      }
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout detail: $e');
      rethrow;
    }
  }

  // ============================================================
  // WORKOUT SESSIONS (POST /workout-sessions)
  // ============================================================

  /// Start a new workout session
  /// POST /workout-sessions/start
  Future<NewWorkoutSessionModel> startWorkoutSession({
    required String workoutId,
    DateTime? startTime,
  }) async {
    try {
      debugPrint('Starting workout session for workout: $workoutId');

      final data = {
        'workoutId': workoutId,
        if (startTime != null) 'startTime': startTime.toIso8601String(),
      };

      final response = await _apiClient.dio.post(
        Api.startWorkoutSession,
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        return NewWorkoutSessionModel.fromJson(response.data);
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error starting workout session: $e');
      rethrow;
    }
  }

  /// Complete workout session
  /// PATCH /workout-sessions/:id/complete
  Future<NewWorkoutSessionModel> completeWorkoutSession({
    required String sessionId,
    DateTime? endTime,
    int? caloriesBurned,
    String? notes,
  }) async {
    try {
      debugPrint('Completing workout session: $sessionId');

      final data = <String, dynamic>{
        if (endTime != null) 'endTime': endTime.toIso8601String(),
        if (caloriesBurned != null) 'caloriesBurned': caloriesBurned,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final response = await _apiClient.dio.patch(
        Api.completeWorkoutSession(sessionId),
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        return NewWorkoutSessionModel.fromJson(response.data);
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error completing workout session: $e');
      rethrow;
    }
  }

  /// Get workout history with pagination
  /// GET /workout-sessions/history
  Future<Map<String, dynamic>> getWorkoutHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      debugPrint('Fetching workout history: page=$page, limit=$limit');

      final response = await _apiClient.dio.get(
        Api.workoutHistory,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        return {
          'data':
              (data['data'] as List<dynamic>?)
                  ?.map((s) => NewWorkoutSessionModel.fromJson(s))
                  .toList() ??
              [],
          'total': data['total'] as int? ?? 0,
          'page': data['page'] as int? ?? 1,
          'limit': data['limit'] as int? ?? 10,
          'totalPages': data['totalPages'] as int? ?? 0,
        };
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout history: $e');
      rethrow;
    }
  }

  /// Get weekly progress
  /// GET /workout-sessions/weekly-progress
  Future<WeeklyProgressModel?> getWeeklyProgress() async {
    try {
      debugPrint('Fetching weekly progress');

      final response = await _apiClient.dio.get(Api.weeklyProgress);

      if (response.data is Map<String, dynamic>) {
        return WeeklyProgressModel.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      debugPrint('DioException fetching weekly progress: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Error fetching weekly progress: $e');
      return null;
    }
  }

  // ============================================================
  // WORKOUT SCHEDULES (GET /workout-schedules)
  // ============================================================

  /// Get all workout schedules
  /// GET /workout-schedules
  Future<List<NewWorkoutScheduleModel>> getWorkoutSchedules() async {
    try {
      debugPrint('Fetching workout schedules');

      final response = await _apiClient.dio.get(Api.workoutSchedules);

      if (response.data is List) {
        return (response.data as List)
            .map((s) => NewWorkoutScheduleModel.fromJson(s))
            .toList();
      }

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .map((s) => NewWorkoutScheduleModel.fromJson(s))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching workout schedules: $e');
      rethrow;
    }
  }

  /// Get upcoming workout schedules
  /// GET /workout-schedules/upcoming
  Future<List<NewWorkoutScheduleModel>> getUpcomingSchedules() async {
    try {
      debugPrint('Fetching upcoming schedules');

      final response = await _apiClient.dio.get(Api.upcomingWorkoutSchedules);

      if (response.data is List) {
        return (response.data as List)
            .map((s) => NewWorkoutScheduleModel.fromJson(s))
            .toList();
      }

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .map((s) => NewWorkoutScheduleModel.fromJson(s))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching upcoming schedules: $e');
      rethrow;
    }
  }

  /// Get today's workout schedules
  Future<List<NewWorkoutScheduleModel>> getTodaySchedules() async {
    try {
      debugPrint('Fetching today schedules');

      final allSchedules = await getWorkoutSchedules();
      return allSchedules.where((s) => s.isToday).toList();
    } catch (e) {
      debugPrint('Error fetching today schedules: $e');
      return [];
    }
  }

  /// Create workout schedule
  /// POST /workout-schedules
  Future<NewWorkoutScheduleModel> createWorkoutSchedule({
    required String workoutId,
    required DateTime scheduledDate,
    String? scheduledTime,
    bool reminderEnabled = false,
  }) async {
    try {
      debugPrint('Creating workout schedule for workout: $workoutId');

      final data = {
        'workoutId': workoutId,
        'scheduledDate': scheduledDate.toIso8601String(),
        if (scheduledTime != null) 'scheduledTime': scheduledTime,
        'reminderEnabled': reminderEnabled,
      };

      final response = await _apiClient.dio.post(
        Api.workoutSchedules,
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        return NewWorkoutScheduleModel.fromJson(response.data);
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error creating workout schedule: $e');
      rethrow;
    }
  }

  /// Update workout schedule
  /// PATCH /workout-schedules/:id
  Future<NewWorkoutScheduleModel> updateWorkoutSchedule({
    required String scheduleId,
    DateTime? scheduledDate,
    String? scheduledTime,
    bool? reminderEnabled,
  }) async {
    try {
      debugPrint('Updating workout schedule: $scheduleId');

      final data = <String, dynamic>{
        if (scheduledDate != null)
          'scheduledDate': scheduledDate.toIso8601String(),
        if (scheduledTime != null) 'scheduledTime': scheduledTime,
        if (reminderEnabled != null) 'reminderEnabled': reminderEnabled,
      };

      final response = await _apiClient.dio.patch(
        Api.updateWorkoutSchedule(scheduleId),
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        return NewWorkoutScheduleModel.fromJson(response.data);
      }

      throw ApiException('Invalid response format');
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error updating workout schedule: $e');
      rethrow;
    }
  }

  /// Delete workout schedule
  /// DELETE /workout-schedules/:id
  Future<void> deleteWorkoutSchedule(String scheduleId) async {
    try {
      debugPrint('Deleting workout schedule: $scheduleId');

      await _apiClient.dio.delete(Api.deleteWorkoutSchedule(scheduleId));
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error deleting workout schedule: $e');
      rethrow;
    }
  }

  /// Toggle reminder for a schedule
  Future<NewWorkoutScheduleModel> toggleScheduleReminder(
    String scheduleId,
    bool isEnabled,
  ) async {
    return updateWorkoutSchedule(
      scheduleId: scheduleId,
      reminderEnabled: isEnabled,
    );
  }

  // ============================================================
  // HELPER METHODS
  // ============================================================

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        // Handle message as both String and List
        final message = data['message'];
        if (message is String) {
          return message;
        } else if (message is List) {
          // Join array messages
          return message.join(', ');
        }
        return 'Unknown error occurred';
      }
      return 'Error: ${e.response?.statusCode}';
    }
    return e.message ?? 'Network error occurred';
  }
}

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/sleep_schedule_model.dart';
import '../models/sleep_record_model.dart';
import '../models/api_response_model.dart';
import '../../utils/api.dart';
import '../../utils/api_client.dart';

/// Sleep Repository for API calls
class SleepRepository {
  final ApiClient _apiClient = ApiClient();

  /// Create a new sleep schedule
  Future<SleepScheduleModel> createSleepSchedule(
    CreateSleepScheduleRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        Api.createSleepSchedule,
        data: request.toJson(),
      );

      return SleepScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get all sleep schedules with optional filtering
  Future<List<SleepScheduleModel>> getSleepSchedules({
    int? month,
    int? year,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (month != null) queryParams['month'] = month;
      if (year != null) queryParams['year'] = year;
      if (isActive != null) queryParams['isActive'] = isActive;

      final response = await _apiClient.dio.get(
        Api.sleepSchedules,
        queryParameters: queryParams,
      );

      // Handle nested API response structure
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load sleep schedules');
      }

      // Extract the actual data from nested response
      final nestedData = apiResponse.data!;
      final List<dynamic> schedulesData = nestedData['data'] as List<dynamic>;

      return schedulesData
          .map(
            (json) => SleepScheduleModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get sleep schedule by ID
  Future<SleepScheduleModel> getSleepScheduleById(String id) async {
    try {
      final response = await _apiClient.dio.get(
        Api.getSleepScheduleByIdUrl(id),
      );

      return SleepScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Update sleep schedule
  Future<SleepScheduleModel> updateSleepSchedule(
    String id,
    UpdateSleepScheduleRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.patch(
        Api.updateSleepScheduleUrl(id),
        data: request.toJson(),
      );

      return SleepScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Delete sleep schedule
  Future<void> deleteSleepSchedule(String id) async {
    try {
      await _apiClient.dio.delete(Api.deleteSleepScheduleUrl(id));
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get sleep calendar data for a specific date
  Future<SleepCalendarDataModel> getSleepCalendarData(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await _apiClient.dio.get(
        Api.sleepCalendar,
        queryParameters: {'date': formattedDate},
      );

      // Handle nested API response structure
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load calendar data');
      }

      // Extract the actual data from nested response
      final calendarData = apiResponse.data!;
      return SleepCalendarDataModel.fromJson(calendarData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get daily sleep summary for a specific date
  Future<SleepDailySummaryModel> getSleepDailySummary(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await _apiClient.dio.get(
        Api.sleepDailySummary,
        queryParameters: {'date': formattedDate},
      );

      // Handle nested API response structure
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load daily summary');
      }

      // Extract the actual data from nested response
      final summaryData = apiResponse.data!;
      return SleepDailySummaryModel.fromJson(summaryData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get sleep activity data for charts (last 7 days)
  Future<List<SleepDailySummaryModel>> getSleepActivityData() async {
    try {
      final List<SleepDailySummaryModel> activityData = [];
      final now = DateTime.now();

      // Get data for last 7 days
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        try {
          final summary = await getSleepDailySummary(date);
          activityData.add(summary);
        } catch (e) {
          // If no data for a specific day, create empty summary
          activityData.add(
            SleepDailySummaryModel(
              date: DateFormat('yyyy-MM-dd').format(date),
              totalSleepTime: 0,
              records: [],
              adherenceToSchedule: false,
            ),
          );
        }
      }

      return activityData;
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get weekly sleep schedule data for current week
  Future<List<SleepCalendarDataModel>> getWeeklyCalendarData(
    DateTime startDate,
  ) async {
    try {
      final List<SleepCalendarDataModel> weekData = [];

      // Get data for 7 days starting from startDate
      for (int i = 0; i < 7; i++) {
        final date = startDate.add(Duration(days: i));
        try {
          final calendarData = await getSleepCalendarData(date);
          weekData.add(calendarData);
        } catch (e) {
          // If no data for a specific day, create empty data
          weekData.add(
            SleepCalendarDataModel(
              date: DateFormat('yyyy-MM-dd').format(date),
              totalSleepDuration: 0,
              averageQuality: 0.0,
              sleepRecords: [],
              activeSchedules: [],
              hasAlarm: false,
            ),
          );
        }
      }

      return weekData;
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Toggle sleep schedule active status
  Future<SleepScheduleModel> toggleScheduleActiveStatus(
    String id,
    bool isActive,
  ) async {
    try {
      final request = UpdateSleepScheduleRequest(isActive: isActive);
      return await updateSleepSchedule(id, request);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Handle DioException errors
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(e);
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred: ${e.message}';
    }
  }

  /// Handle bad response errors
  String _handleBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    switch (statusCode) {
      case 400:
        if (data != null && data['message'] != null) {
          return data['message'];
        }
        return 'Bad Request: Invalid data provided';
      case 401:
        return 'Unauthorized: Please login again';
      case 403:
        return 'Forbidden: You don\'t have permission to access this resource';
      case 404:
        return 'Not Found: Resource does not exist';
      case 409:
        if (data != null && data['message'] != null) {
          return data['message'];
        }
        return 'Conflict: Schedule conflict detected';
      case 422:
        if (data != null && data['message'] != null) {
          return data['message'];
        }
        return 'Validation Error: Please check your input';
      case 429:
        return 'Too Many Requests: Please try again later';
      case 500:
        return 'Server Error: Please try again later';
      case 502:
        return 'Bad Gateway: Server is temporarily unavailable';
      case 503:
        return 'Service Unavailable: Please try again later';
      default:
        if (data != null && data['message'] != null) {
          return data['message'];
        }
        return 'Server Error: Please try again later (${statusCode ?? 'Unknown'})';
    }
  }
}

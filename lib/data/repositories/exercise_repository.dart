import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../models/api_response_model.dart';
import '../../utils/api.dart';
import '../../utils/api_client.dart';

/// Exercise Repository for API calls
class ExerciseRepository {
  final ApiClient _apiClient = ApiClient();

  /// Get exercises with filtering and pagination
  Future<ExerciseListResponseModel> getExercises({
    ExerciseQueryParams? params,
  }) async {
    try {
      final queryParams = params?.toQueryMap() ?? {'page': 1, 'limit': 20};

      debugPrint('Fetching exercises with params: $queryParams');

      final response = await _apiClient.dio.get(
        Api.exercises,
        queryParameters: queryParams,
      );

      // Handle API response
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load exercises');
      }

      // Parse the response data
      final responseData = apiResponse.data!;

      // Check if data is nested
      if (responseData.containsKey('data') && responseData['data'] is List) {
        return ExerciseListResponseModel.fromJson(responseData);
      }

      // If the response is direct
      return ExerciseListResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching exercises: $e');
      rethrow;
    }
  }

  /// Get exercise by ID
  Future<ExerciseModel> getExerciseById(String id) async {
    try {
      debugPrint('Fetching exercise with ID: $id');

      final response = await _apiClient.dio.get(Api.getExerciseById(id));

      // Handle API response
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load exercise details');
      }

      // Check if data is nested
      final responseData = apiResponse.data!;
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return ExerciseModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      }

      return ExerciseModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching exercise details: $e');
      rethrow;
    }
  }

  /// Get exercise types
  Future<List<FilterOptionModel>> getExerciseTypes() async {
    try {
      final response = await _apiClient.dio.get(Api.exerciseTypes);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load exercise types');
      }

      final data = apiResponse.data!;
      final types = data['types'] ?? data['data'] ?? [];

      return (types as List<dynamic>)
          .map(
            (e) => FilterOptionModel.fromJson(
              e is String
                  ? {'value': e, 'label': e}
                  : e as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching exercise types: $e');
      rethrow;
    }
  }

  /// Get body parts
  Future<List<FilterOptionModel>> getBodyParts() async {
    try {
      final response = await _apiClient.dio.get(Api.exerciseBodyParts);

      debugPrint('Body parts response: ${response.data}');

      // Handle response - data is directly a List
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;

        // Check if success
        if (responseMap['success'] == false) {
          throw ApiException('Failed to load body parts');
        }

        // Get data field - it's a List of strings
        final data = responseMap['data'];

        if (data == null) {
          debugPrint('Body parts data is null');
          return [];
        }

        // Convert List<String> to List<FilterOptionModel>
        if (data is List) {
          return data.map((item) {
            if (item is String) {
              return FilterOptionModel(
                value: item,
                label: _formatBodyPartLabel(item),
              );
            } else if (item is Map<String, dynamic>) {
              return FilterOptionModel.fromJson(item);
            }
            return FilterOptionModel(
              value: item.toString(),
              label: item.toString(),
            );
          }).toList();
        }
      }

      return [];
    } on DioException catch (e) {
      debugPrint('DioException fetching body parts: ${e.message}');
      return []; // Return empty list on error
    } catch (e) {
      debugPrint('Error fetching body parts: $e');
      return []; // Return empty list on error
    }
  }

  /// Format body part label (capitalize)
  String _formatBodyPartLabel(String value) {
    if (value.isEmpty) return value;
    return value
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Get equipments
  Future<List<FilterOptionModel>> getEquipments() async {
    try {
      final response = await _apiClient.dio.get(Api.exerciseEquipments);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load equipments');
      }

      final data = apiResponse.data!;
      final equipments = data['equipments'] ?? data['data'] ?? [];

      return (equipments as List<dynamic>)
          .map(
            (e) => FilterOptionModel.fromJson(
              e is String
                  ? {'value': e, 'label': e}
                  : e as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching equipments: $e');
      rethrow;
    }
  }

  /// Get target muscles
  Future<List<FilterOptionModel>> getTargetMuscles() async {
    try {
      final response = await _apiClient.dio.get(Api.exerciseTargetMuscles);

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException('Failed to load target muscles');
      }

      final data = apiResponse.data!;
      final targetMuscles = data['targetMuscles'] ?? data['data'] ?? [];

      return (targetMuscles as List<dynamic>)
          .map(
            (e) => FilterOptionModel.fromJson(
              e is String
                  ? {'value': e, 'label': e}
                  : e as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    } catch (e) {
      debugPrint('Error fetching target muscles: $e');
      rethrow;
    }
  }

  /// Get all filter options
  Future<ExerciseFiltersModel> getAllFilters() async {
    try {
      final results = await Future.wait([
        getExerciseTypes(),
        getBodyParts(),
        getEquipments(),
        getTargetMuscles(),
      ]);

      // Default difficulties
      final difficulties = [
        const FilterOptionModel(value: 'beginner', label: 'Beginner'),
        const FilterOptionModel(value: 'intermediate', label: 'Intermediate'),
        const FilterOptionModel(value: 'advanced', label: 'Advanced'),
      ];

      return ExerciseFiltersModel(
        applied: {},
        types: results[0],
        bodyParts: results[1],
        equipments: results[2],
        targetMuscles: results[3],
        difficulties: difficulties,
      );
    } catch (e) {
      debugPrint('Error fetching all filters: $e');
      rethrow;
    }
  }

  /// Search exercises
  Future<ExerciseListResponseModel> searchExercises({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    return getExercises(
      params: ExerciseQueryParams(page: page, limit: limit, search: query),
    );
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

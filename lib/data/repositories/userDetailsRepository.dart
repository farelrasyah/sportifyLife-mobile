import 'package:dio/dio.dart';
import '../models/userDetailsModel.dart';
import '../models/apiResponseModel.dart';
import '../../utils/api.dart';
import '../../utils/apiClient.dart';

/// User details repository for API calls
class UserDetailsRepository {
  final ApiClient _apiClient = ApiClient();

  /// Get user details
  Future<UserDetailsModel?> getUserDetails() async {
    try {
      final response = await _apiClient.dio.get(Api.getUserDetails);

      final apiResponse = ApiResponseModel.fromJson(
        response.data,
        (data) => UserDetailsModel.fromJson(data as Map<String, dynamic>),
      );

      return apiResponse.data;
    } on DioException catch (e) {
      // If 404, user details don't exist yet
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException(_handleError(e));
    }
  }

  /// Complete user profile (first time)
  Future<UserDetailsModel> completeProfile({
    required double weight,
    required int height,
    required String gender,
    required DateTime dateOfBirth,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Api.completeProfile,
        data: {
          'weight': weight,
          'height': height,
          'gender': gender,
          'dateOfBirth': dateOfBirth.toIso8601String(),
          'phoneNumber': phoneNumber,
        },
      );

      final apiResponse = ApiResponseModel.fromJson(
        response.data,
        (data) => UserDetailsModel.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw ApiException('Failed to complete profile');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Update user details
  Future<UserDetailsModel> updateUserDetails({
    double? weight,
    int? height,
    String? gender,
    DateTime? dateOfBirth,
    String? phoneNumber,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (weight != null) data['weight'] = weight;
      if (height != null) data['height'] = height;
      if (gender != null) data['gender'] = gender;
      if (dateOfBirth != null)
        data['dateOfBirth'] = dateOfBirth.toIso8601String();
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;

      final response = await _apiClient.dio.put(
        Api.updateUserDetails,
        data: data,
      );

      final apiResponse = ApiResponseModel.fromJson(
        response.data,
        (data) => UserDetailsModel.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw ApiException('Failed to update profile');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Error handler
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? 'An error occurred';
      }
      return error.response!.statusMessage ?? 'An error occurred';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    }

    return error.message ?? 'An error occurred';
  }
}

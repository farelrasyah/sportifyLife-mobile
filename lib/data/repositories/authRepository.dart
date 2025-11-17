import 'package:dio/dio.dart';
import '../models/authResponseModel.dart';
import '../models/userModel.dart';
import '../models/apiResponseModel.dart';
import '../../utils/api.dart';
import '../../utils/apiClient.dart';

/// Auth repository for API calls
class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  /// Register new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Api.register,
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Login user
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Api.login,
        data: {'email': email, 'password': password},
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Verify email with token
  Future<String> verifyEmail(String token) async {
    try {
      final response = await _apiClient.dio.get(
        Api.verifyEmail,
        queryParameters: {'token': token},
      );

      final apiResponse = ApiResponseModel.fromJson(response.data, null);
      return apiResponse.message ?? 'Email verified successfully';
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Resend verification email
  Future<String> resendVerification(String email) async {
    try {
      final response = await _apiClient.dio.post(
        Api.resendVerification,
        data: {'email': email},
      );

      final apiResponse = ApiResponseModel.fromJson(response.data, null);
      return apiResponse.message ?? 'Verification email sent';
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(Api.currentUser);

      final apiResponse = ApiResponseModel.fromJson(
        response.data,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw ApiException('User data not found');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.dio.post(Api.logout);
      await _apiClient.reset();
    } on DioException catch (e) {
      // Even if logout fails on server, clear local data
      await _apiClient.reset();
      throw ApiException(_handleError(e));
    }
  }

  /// Forgot password
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        Api.forgotPassword,
        data: {'email': email},
      );

      final apiResponse = ApiResponseModel.fromJson(response.data, null);
      return apiResponse.message ?? 'Password reset email sent';
    } on DioException catch (e) {
      throw ApiException(_handleError(e));
    }
  }

  /// Change password
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        Api.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      final apiResponse = ApiResponseModel.fromJson(response.data, null);
      return apiResponse.message ?? 'Password changed successfully';
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

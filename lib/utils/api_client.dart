import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'storage_helper.dart';

/// Dio API Client with interceptors
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;
  final StorageHelper _storage = StorageHelper();

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiUrl,
        connectTimeout: Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.requestTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Request Interceptor - Add Authorization Token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            print('┌─────────────────────────────────────────────────────');
            print('│ 🌐 REQUEST: ${options.method} ${options.path}');
            print('│ 📦 Data: ${options.data}');
            print('│ 🔑 Headers: ${options.headers}');
            print('└─────────────────────────────────────────────────────');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('┌─────────────────────────────────────────────────────');
            print(
              '│ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
            );
            print('│ 📦 Data: ${response.data}');
            print('└─────────────────────────────────────────────────────');
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('┌─────────────────────────────────────────────────────');
            print(
              '│ ❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}',
            );
            print('│ 📦 Message: ${error.message}');
            print('│ 📦 Data: ${error.response?.data}');
            print('└─────────────────────────────────────────────────────');
          }

          // Handle 401 Unauthorized - Token expired
          if (error.response?.statusCode == 401) {
            // TODO: Implement refresh token logic
            // For now, clear storage and redirect to login
            await _storage.clearAll();
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Reset client (useful for logout)
  Future<void> reset() async {
    await _storage.clearAll();
  }

  /// POST request wrapper
  Future<Response> postRequest(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('POST request failed: ${e.message}');
    }
  }

  /// GET request wrapper
  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw Exception('GET request failed: ${e.message}');
    }
  }

  /// PUT request wrapper
  Future<Response> putRequest(String path, {dynamic data}) async {
    try {
      final response = await dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('PUT request failed: ${e.message}');
    }
  }

  /// DELETE request wrapper
  Future<Response> deleteRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw Exception('DELETE request failed: ${e.message}');
    }
  }
}

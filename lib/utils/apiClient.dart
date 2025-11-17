import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'storageHelper.dart';

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
}

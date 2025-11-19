import 'package:dio/dio.dart';
import '../core/result.dart';
import '../config/environment.dart';
import '../utils/storage_helper.dart';

/// HTTP Service for making API requests
/// Uses Dio with proper error handling and token injection
class HttpService {
  final Dio _dio;
  final StorageHelper _storage;

  HttpService({Dio? dio, StorageHelper? storage})
    : _dio = dio ?? Dio(),
      _storage = storage ?? StorageHelper() {
    _configureDio();
  }

  /// Configure Dio with interceptors and base options
  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout: Duration(milliseconds: Environment.connectTimeout),
      receiveTimeout: Duration(milliseconds: Environment.requestTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add request interceptor for authentication
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Inject Bearer token from secure storage
          final token = await _storage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request in debug mode
          if (Environment.enableApiLogging) {
            print('┌─────────────────────────────────────────────────────');
            print('│ 🌐 REQUEST: ${options.method} ${options.path}');
            print('│ 📦 Data: ${options.data}');
            print('│ 🔑 Headers: ${options.headers}');
            print('└─────────────────────────────────────────────────────');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response in debug mode
          if (Environment.enableApiLogging) {
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
          // Log error in debug mode
          if (Environment.enableApiLogging) {
            print('┌─────────────────────────────────────────────────────');
            print(
              '│ ❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}',
            );
            print('│ 📦 Message: ${error.message}');
            print('│ 📦 Data: ${error.response?.data}');
            print('└─────────────────────────────────────────────────────');
          }

          // Handle 401 Unauthorized - Token expired/invalid
          if (error.response?.statusCode == 401) {
            // TODO: Implement token refresh logic
            // For now, clear storage (will redirect to login)
            await _storage.clearAll();
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Make GET request
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final data = _extractData(response.data);
        return Success(fromJson(data));
      }

      return Failure(
        ServiceError.fromStatusCode(
          response.statusCode ?? 0,
          'Request failed with status ${response.statusCode}',
        ),
      );
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(ServiceError.unknown(e.toString()));
    }
  }

  /// Make POST request
  Future<Result<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = _extractData(response.data);
        return Success(fromJson(responseData));
      }

      return Failure(
        ServiceError.fromStatusCode(
          response.statusCode ?? 0,
          'Request failed with status ${response.statusCode}',
        ),
      );
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(ServiceError.unknown(e.toString()));
    }
  }

  /// Make PUT request
  Future<Result<T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.put(path, data: data);

      if (response.statusCode == 200) {
        final responseData = _extractData(response.data);
        return Success(fromJson(responseData));
      }

      return Failure(
        ServiceError.fromStatusCode(
          response.statusCode ?? 0,
          'Request failed with status ${response.statusCode}',
        ),
      );
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(ServiceError.unknown(e.toString()));
    }
  }

  /// Make DELETE request
  Future<Result<void>> delete(String path) async {
    try {
      final response = await _dio.delete(path);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Success(null);
      }

      return Failure(
        ServiceError.fromStatusCode(
          response.statusCode ?? 0,
          'Request failed with status ${response.statusCode}',
        ),
      );
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(ServiceError.unknown(e.toString()));
    }
  }

  /// Extract data from API response
  /// Backend response format: { success: bool, message: string, data: T }
  dynamic _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // If response has 'data' field, extract it
      if (responseData.containsKey('data')) {
        return responseData['data'];
      }
      // Otherwise return the whole response
      return responseData;
    }
    return responseData;
  }

  /// Handle Dio errors and convert to ServiceError
  ServiceError _handleDioError(DioException error) {
    final response = error.response;

    // Network errors (no response)
    if (response == null) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return ServiceError.network('Connection timeout. Please try again.');
      }

      if (error.type == DioExceptionType.connectionError) {
        return ServiceError.network(
          'No internet connection. Please check your network.',
        );
      }

      return ServiceError.network(error.message ?? 'Network error occurred');
    }

    // Parse error response from backend
    final data = response.data;
    String message = 'An error occurred';
    List<String>? validationErrors;

    if (data is Map<String, dynamic>) {
      // Extract message field
      message = data['message'] as String? ?? message;

      // Extract validation errors (could be array or string)
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List) {
          validationErrors = errors.map((e) => e.toString()).toList();
        } else if (errors is String) {
          validationErrors = [errors];
        }
      }

      // Some APIs return error field instead of message
      if (data.containsKey('error') && data['error'] is String) {
        message = data['error'] as String;
      }
    }

    // Create appropriate error based on status code
    final statusCode = response.statusCode ?? 0;

    if (statusCode == 400) {
      return ServiceError.validation(
        message,
        validationErrors: validationErrors,
      );
    }

    if (statusCode == 401 || statusCode == 403) {
      return ServiceError.auth(message);
    }

    if (statusCode == 409) {
      // Conflict - usually duplicate resource (email already exists, etc)
      return ServiceError.validation(message);
    }

    if (statusCode >= 500) {
      return ServiceError.server(message);
    }

    return ServiceError.fromStatusCode(statusCode, message);
  }

  /// Clear authentication (for logout)
  Future<void> clearAuth() async {
    await _storage.clearAll();
  }
}

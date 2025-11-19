/// Generic result type for service operations
/// Wraps success data or failure errors
sealed class Result<T> {
  const Result();

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  /// Get error if failure, null otherwise
  ServiceError? get errorOrNull => switch (this) {
    Success() => null,
    Failure(error: final error) => error,
  };

  /// Transform success data, keep failure unchanged
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(data: final data) => Success(transform(data)),
      Failure(error: final error) => Failure(error),
    };
  }

  /// Execute callback based on result type
  R when<R>({
    required R Function(T data) success,
    required R Function(ServiceError error) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(error: final error) => failure(error),
    };
  }
}

/// Success result with data
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// Failure result with error
final class Failure<T> extends Result<T> {
  final ServiceError error;

  const Failure(this.error);
}

/// Service error with structured information
class ServiceError {
  final int? statusCode;
  final String message;
  final List<String>? validationErrors;
  final String? errorCode;
  final dynamic originalError;

  const ServiceError({
    this.statusCode,
    required this.message,
    this.validationErrors,
    this.errorCode,
    this.originalError,
  });

  /// Check if error is network-related
  bool get isNetworkError =>
      statusCode == null ||
      statusCode == 0 ||
      message.contains('connection') ||
      message.contains('network');

  /// Check if error is authentication-related
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  /// Check if error is validation-related
  bool get isValidationError =>
      statusCode == 400 || (validationErrors?.isNotEmpty ?? false);

  /// Check if error is server-related
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Get user-friendly error message
  String get userMessage {
    // Show validation errors if available
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      return validationErrors!.join('\n');
    }

    // Show specific messages for common errors
    if (isNetworkError) {
      return 'No internet connection. Please check your network.';
    }

    if (isAuthError) {
      return 'Authentication failed. Please login again.';
    }

    if (isServerError) {
      return 'Server error. Please try again later.';
    }

    // Default to the message from backend
    return message;
  }

  /// Create from HTTP status code and message
  factory ServiceError.fromStatusCode(int statusCode, String message) {
    return ServiceError(statusCode: statusCode, message: message);
  }

  /// Create network error
  factory ServiceError.network(String message) {
    return ServiceError(statusCode: null, message: message);
  }

  /// Create validation error
  factory ServiceError.validation(
    String message, {
    List<String>? validationErrors,
  }) {
    return ServiceError(
      statusCode: 400,
      message: message,
      validationErrors: validationErrors,
    );
  }

  /// Create authentication error
  factory ServiceError.auth(String message) {
    return ServiceError(statusCode: 401, message: message);
  }

  /// Create server error
  factory ServiceError.server(String message) {
    return ServiceError(statusCode: 500, message: message);
  }

  /// Create unknown error
  factory ServiceError.unknown(String message) {
    return ServiceError(statusCode: null, message: message);
  }

  @override
  String toString() {
    return 'ServiceError(statusCode: $statusCode, message: $message, validationErrors: $validationErrors)';
  }
}

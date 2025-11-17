/// Generic API response model
class ApiResponseModel<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;

  ApiResponseModel({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return ApiResponseModel<T>(
      success: json['success'] as bool? ?? false,
      data: dataParser != null && json['data'] != null
          ? dataParser(json['data'])
          : json['data'] as T?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'error': error,
      'statusCode': statusCode,
    };
  }
}

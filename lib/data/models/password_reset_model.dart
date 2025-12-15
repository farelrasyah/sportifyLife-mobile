/// Password Reset Response Model
/// Handles API responses for password reset operations
class PasswordResetResponseModel {
  final String message;

  PasswordResetResponseModel({required this.message});

  factory PasswordResetResponseModel.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponseModel(
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

/// OTP Verification Response Model
/// Handles API responses for OTP verification
class OtpVerificationResponseModel {
  final String message;
  final bool isValid;

  OtpVerificationResponseModel({required this.message, required this.isValid});

  factory OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponseModel(
      message: json['message'] as String? ?? '',
      isValid: json['isValid'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'isValid': isValid};
  }
}

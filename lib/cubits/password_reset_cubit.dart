import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/auth_service.dart';
import '../data/models/password_reset_model.dart';

/// Password Reset States
abstract class PasswordResetState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state - no action taken
class PasswordResetInitial extends PasswordResetState {}

/// Loading state for any password reset operation
class PasswordResetLoading extends PasswordResetState {}

/// OTP sent successfully to email
class PasswordResetOtpSent extends PasswordResetState {
  final String message;
  final String email;

  PasswordResetOtpSent({required this.message, required this.email});

  @override
  List<Object?> get props => [message, email];
}

/// OTP verified successfully
class PasswordResetOtpVerified extends PasswordResetState {
  final String message;
  final String email;
  final String otp;

  PasswordResetOtpVerified({
    required this.message,
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [message, email, otp];
}

/// Password reset completed successfully
class PasswordResetSuccess extends PasswordResetState {
  final String message;

  PasswordResetSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state for password reset operations
class PasswordResetError extends PasswordResetState {
  final String error;
  final bool canRetry;

  PasswordResetError({required this.error, this.canRetry = true});

  @override
  List<Object?> get props => [error, canRetry];
}

/// Password Reset Cubit
/// Manages the complete password reset flow with OTP verification
class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthService _authService;

  // Store email and OTP for the flow
  String? _currentEmail;
  String? _currentOtp;

  PasswordResetCubit({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(PasswordResetInitial());

  /// Step 1: Request password reset OTP
  /// Sends OTP to user's email address
  Future<void> requestPasswordReset(String email) async {
    try {
      emit(PasswordResetLoading());

      final result = await _authService.requestPasswordResetOtp(email: email);

      result.when(
        success: (response) {
          _currentEmail = email;
          emit(PasswordResetOtpSent(message: response.message, email: email));
        },
        failure: (error) {
          emit(PasswordResetError(error: error.userMessage));
        },
      );
    } catch (e) {
      emit(
        PasswordResetError(error: 'Failed to send reset code: ${e.toString()}'),
      );
    }
  }

  /// Step 2: Verify OTP code
  /// Validates the OTP sent to user's email
  Future<void> verifyOtp(String email, String otp) async {
    try {
      emit(PasswordResetLoading());

      final result = await _authService.verifyOtp(email: email, otp: otp);

      result.when(
        success: (response) {
          if (response.isValid) {
            _currentEmail = email;
            _currentOtp = otp;
            emit(
              PasswordResetOtpVerified(
                message: response.message,
                email: email,
                otp: otp,
              ),
            );
          } else {
            emit(
              PasswordResetError(
                error: response.message.isNotEmpty
                    ? response.message
                    : 'Invalid or expired OTP code',
              ),
            );
          }
        },
        failure: (error) {
          emit(PasswordResetError(error: error.userMessage));
        },
      );
    } catch (e) {
      emit(PasswordResetError(error: 'Failed to verify OTP: ${e.toString()}'));
    }
  }

  /// Step 3: Reset password
  /// Changes user's password using verified OTP
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      emit(PasswordResetLoading());

      final result = await _authService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      result.when(
        success: (response) {
          // Clear stored data
          _currentEmail = null;
          _currentOtp = null;
          emit(PasswordResetSuccess(message: response.message));
        },
        failure: (error) {
          emit(PasswordResetError(error: error.userMessage));
        },
      );
    } catch (e) {
      emit(
        PasswordResetError(error: 'Failed to reset password: ${e.toString()}'),
      );
    }
  }

  /// Reset the state to initial
  void reset() {
    _currentEmail = null;
    _currentOtp = null;
    emit(PasswordResetInitial());
  }

  /// Get current email (useful for maintaining state across screens)
  String? get currentEmail => _currentEmail;

  /// Get current OTP (useful for maintaining state across screens)
  String? get currentOtp => _currentOtp;

  /// Resend OTP (same as request password reset)
  Future<void> resendOtp() async {
    if (_currentEmail != null) {
      await requestPasswordReset(_currentEmail!);
    } else {
      emit(
        PasswordResetError(
          error: 'No email found. Please start the reset process again.',
        ),
      );
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/verification_service.dart';
import '../data/models/user_model.dart';
import '../config/environment.dart';

// ============================================================================
// STATES
// ============================================================================

abstract class VerifyState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state - no verification process started
class VerifyInitial extends VerifyState {}

/// Verification link sent, waiting for user to verify
class VerifyPending extends VerifyState {
  final String email;
  final DateTime expiresAt;
  final Duration remainingTime;
  final bool isChecking; // True when auto-checking verification status

  VerifyPending({
    required this.email,
    required this.expiresAt,
    required this.remainingTime,
    this.isChecking = false,
  });

  @override
  List<Object?> get props => [email, expiresAt, remainingTime, isChecking];
}

/// Loading state for manual actions (resend, verify with token)
class VerifyLoading extends VerifyState {}

/// Email verified successfully
class VerifySuccess extends VerifyState {
  final UserModel user;
  final String message;

  VerifySuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// Verification error occurred
class VerifyError extends VerifyState {
  final String error;
  final bool canRetry;

  VerifyError(this.error, {this.canRetry = true});

  @override
  List<Object?> get props => [error, canRetry];
}

/// Verification link expired
class VerifyExpired extends VerifyState {
  final String email;

  VerifyExpired(this.email);

  @override
  List<Object?> get props => [email];
}

// ============================================================================
// CUBIT
// ============================================================================

class VerifyCubit extends Cubit<VerifyState> {
  final VerificationService _verificationService;
  Timer? _countdownTimer;
  StreamSubscription? _autoCheckSubscription;

  VerifyCubit({VerificationService? verificationService})
    : _verificationService = verificationService ?? VerificationService(),
      super(VerifyInitial());

  /// Start verification countdown with auto-check
  /// Automatically polls backend to check if email is verified
  void startVerificationFlow(String email, DateTime expiresAt) {
    _cancelTimers();

    final now = DateTime.now();
    if (expiresAt.isBefore(now)) {
      emit(VerifyExpired(email));
      return;
    }

    emit(
      VerifyPending(
        email: email,
        expiresAt: expiresAt,
        remainingTime: expiresAt.difference(now),
      ),
    );

    // Start countdown timer
    _startCountdown(email, expiresAt);

    // Start auto-checking verification status
    _startAutoCheck(email);
  }

  /// Start countdown timer (updates UI every second)
  void _startCountdown(String email, DateTime expiresAt) {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      if (expiresAt.isBefore(now)) {
        timer.cancel();
        emit(VerifyExpired(email));
      } else {
        final currentState = state;
        if (currentState is VerifyPending) {
          emit(
            VerifyPending(
              email: email,
              expiresAt: expiresAt,
              remainingTime: expiresAt.difference(now),
              isChecking: currentState.isChecking,
            ),
          );
        }
      }
    });
  }

  /// Start auto-checking verification status
  /// Polls backend every 5 seconds to check if email is verified
  void _startAutoCheck(String email) {
    _autoCheckSubscription?.cancel();

    _autoCheckSubscription = _verificationService
        .autoCheckVerification(
          interval: const Duration(seconds: 5),
          maxAttempts: 20, // Check for up to 100 seconds
        )
        .listen(
          (result) {
            result.when(
              success: (status) {
                if (status.isVerified) {
                  // Email verified! Stop checking and navigate
                  _cancelTimers();
                  emit(
                    VerifySuccess(
                      user: status.user,
                      message: 'Email verified successfully! Logging you in...',
                    ),
                  );
                } else {
                  // Still not verified, update UI to show we're checking
                  final currentState = state;
                  if (currentState is VerifyPending) {
                    emit(
                      VerifyPending(
                        email: currentState.email,
                        expiresAt: currentState.expiresAt,
                        remainingTime: currentState.remainingTime,
                        isChecking: true,
                      ),
                    );
                  }
                }
              },
              failure: (error) {
                // Don't emit error for auto-check failures
                // Just continue checking silently
                if (Environment.isDebugMode) {
                  print('Auto-check error: ${error.message}');
                }
              },
            );
          },
          onError: (error) {
            if (Environment.isDebugMode) {
              print('Auto-check stream error: $error');
            }
          },
        );
  }

  /// Manually check verification status
  /// Called when user manually clicks "Check Status" button
  Future<void> checkVerificationStatus() async {
    final currentState = state;
    if (currentState is! VerifyPending) return;

    try {
      emit(VerifyLoading());

      final result = await _verificationService.checkVerificationStatus();

      result.when(
        success: (status) {
          if (status.isVerified) {
            _cancelTimers();
            emit(
              VerifySuccess(
                user: status.user,
                message: 'Email verified successfully! Logging you in...',
              ),
            );
          } else {
            // Not verified yet, go back to pending state
            emit(
              VerifyPending(
                email: currentState.email,
                expiresAt: currentState.expiresAt,
                remainingTime: currentState.expiresAt.difference(
                  DateTime.now(),
                ),
              ),
            );
            emit(
              VerifyError(
                'Email not yet verified. Please check your inbox.',
                canRetry: true,
              ),
            );
            // Return to pending state after showing error
            Future.delayed(const Duration(seconds: 2), () {
              if (state is VerifyError) {
                emit(
                  VerifyPending(
                    email: currentState.email,
                    expiresAt: currentState.expiresAt,
                    remainingTime: currentState.expiresAt.difference(
                      DateTime.now(),
                    ),
                  ),
                );
              }
            });
          }
        },
        failure: (error) {
          emit(VerifyError(error.userMessage, canRetry: true));
          // Return to pending state after showing error
          Future.delayed(const Duration(seconds: 2), () {
            if (state is VerifyError) {
              emit(
                VerifyPending(
                  email: currentState.email,
                  expiresAt: currentState.expiresAt,
                  remainingTime: currentState.expiresAt.difference(
                    DateTime.now(),
                  ),
                ),
              );
            }
          });
        },
      );
    } catch (e) {
      emit(VerifyError(e.toString(), canRetry: true));
    }
  }

  /// Verify email with token (from deep link)
  /// Called when user clicks verification link in email
  Future<void> verifyWithToken(String token) async {
    try {
      emit(VerifyLoading());
      _cancelTimers();

      final result = await _verificationService.verifyEmail(token);

      result.when(
        success: (message) async {
          // After verification, get user data
          final statusResult = await _verificationService
              .checkVerificationStatus();

          statusResult.when(
            success: (status) {
              emit(VerifySuccess(user: status.user, message: message));
            },
            failure: (error) {
              // Verification succeeded but couldn't get user data
              // This is acceptable, just show success message
              emit(
                VerifyError(
                  'Email verified but could not load profile. Please try logging in.',
                  canRetry: false,
                ),
              );
            },
          );
        },
        failure: (error) {
          emit(VerifyError(error.userMessage, canRetry: false));
        },
      );
    } catch (e) {
      emit(VerifyError(e.toString(), canRetry: false));
    }
  }

  /// Resend verification email
  Future<void> resendVerification(String email) async {
    try {
      final currentState = state;
      emit(VerifyLoading());
      _cancelTimers();

      final result = await _verificationService.resendVerification(email);

      result.when(
        success: (message) {
          // Calculate new expiry time
          final newExpiresAt = _verificationService.calculateExpiry();

          // Restart verification flow with new expiry
          startVerificationFlow(email, newExpiresAt);

          // Show success message briefly
          emit(
            VerifySuccess(
              user: UserModel(
                id: '',
                email: email,
                firstName: '',
                lastName: '',
                provider: 'local',
                isVerified: false,
                createdAt: null,
                updatedAt: null,
              ),
              message: message,
            ),
          );

          // Return to pending state after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (state is VerifySuccess) {
              startVerificationFlow(email, newExpiresAt);
            }
          });
        },
        failure: (error) {
          emit(VerifyError(error.userMessage, canRetry: true));

          // Return to previous state if possible
          if (currentState is VerifyPending) {
            Future.delayed(const Duration(seconds: 2), () {
              if (state is VerifyError) {
                emit(currentState);
                _startCountdown(currentState.email, currentState.expiresAt);
              }
            });
          }
        },
      );
    } catch (e) {
      emit(VerifyError(e.toString(), canRetry: true));
    }
  }

  /// Cancel all timers and subscriptions
  void _cancelTimers() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _autoCheckSubscription?.cancel();
    _autoCheckSubscription = null;
  }

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }
}

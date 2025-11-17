import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/authRepository.dart';
import '../utils/constants.dart';

// States
abstract class VerifyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyInitial extends VerifyState {}

class VerifyPending extends VerifyState {
  final String email;
  final DateTime expiresAt;
  final Duration remainingTime;

  VerifyPending({
    required this.email,
    required this.expiresAt,
    required this.remainingTime,
  });

  @override
  List<Object?> get props => [email, expiresAt, remainingTime];
}

class VerifyLoading extends VerifyState {}

class VerifySuccess extends VerifyState {
  final String message;
  VerifySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class VerifyError extends VerifyState {
  final String error;
  VerifyError(this.error);

  @override
  List<Object?> get props => [error];
}

class VerifyExpired extends VerifyState {
  final String email;
  VerifyExpired(this.email);

  @override
  List<Object?> get props => [email];
}

// Cubit
class VerifyCubit extends Cubit<VerifyState> {
  final AuthRepository _repository;
  Timer? _countdownTimer;

  VerifyCubit(this._repository) : super(VerifyInitial());

  /// Start verification countdown
  void startPendingCountdown(String email, DateTime expiresAt) {
    _countdownTimer?.cancel();

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

    // Update countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (expiresAt.isBefore(now)) {
        timer.cancel();
        emit(VerifyExpired(email));
      } else {
        emit(
          VerifyPending(
            email: email,
            expiresAt: expiresAt,
            remainingTime: expiresAt.difference(now),
          ),
        );
      }
    });
  }

  /// Verify email with token
  Future<void> verifyEmail(String token) async {
    try {
      emit(VerifyLoading());
      _countdownTimer?.cancel();

      final message = await _repository.verifyEmail(token);
      emit(VerifySuccess(message));
    } catch (e) {
      emit(VerifyError(e.toString()));
    }
  }

  /// Resend verification email
  Future<void> resendVerification(String email) async {
    try {
      emit(VerifyLoading());
      _countdownTimer?.cancel();

      final message = await _repository.resendVerification(email);

      // Start new countdown
      final newExpiresAt = DateTime.now().add(
        AppConstants.verificationTokenExpiry,
      );
      startPendingCountdown(email, newExpiresAt);

      // Optionally show success message
      emit(VerifySuccess(message));
      await Future.delayed(const Duration(seconds: 2));
      startPendingCountdown(email, newExpiresAt);
    } catch (e) {
      emit(VerifyError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}

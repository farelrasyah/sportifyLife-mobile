import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/userModel.dart';
import '../data/repositories/authRepository.dart';
import '../utils/storageHelper.dart';
import '../utils/constants.dart';

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  final bool needsVerification;
  final bool needsProfileCompletion;

  AuthSuccess({
    required this.user,
    this.needsVerification = false,
    this.needsProfileCompletion = false,
  });

  @override
  List<Object?> get props => [user, needsVerification, needsProfileCompletion];
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthUnauthenticated extends AuthState {}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final StorageHelper _storage = StorageHelper();

  AuthCubit(this._repository) : super(AuthInitial());

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    try {
      emit(AuthLoading());

      final response = await _repository.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
      );

      // Save tokens and user data
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);
      await _storage.saveUserEmail(response.user.email);
      await _storage.saveUserId(response.user.id);

      // Save verification expiry
      final expiresAt = DateTime.now().add(
        AppConstants.verificationTokenExpiry,
      );
      await _storage.saveVerificationExpiry(expiresAt);

      emit(
        AuthSuccess(
          user: response.user,
          needsVerification: !response.user.isVerified,
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Login user
  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final response = await _repository.login(
        email: email,
        password: password,
      );

      // Save tokens and user data
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);
      await _storage.saveUserEmail(response.user.email);
      await _storage.saveUserId(response.user.id);

      // Check if user needs verification or profile completion
      // Note: Profile completion check will be done in next screen
      emit(
        AuthSuccess(
          user: response.user,
          needsVerification: !response.user.isVerified,
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await _storage.isLoggedIn();

      if (!isLoggedIn) {
        emit(AuthUnauthenticated());
        return;
      }

      final user = await _repository.getCurrentUser();

      emit(AuthSuccess(user: user, needsVerification: !user.isVerified));
    } catch (e) {
      await _storage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _repository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Even if server logout fails, clear local data
      await _storage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  /// Update user after verification
  void updateUserAfterVerification(UserModel user) {
    emit(AuthSuccess(user: user, needsVerification: false));
  }
}

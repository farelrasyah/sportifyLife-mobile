import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/user_model.dart';
import '../services/auth_service.dart';
import '../services/verification_service.dart';
import '../utils/storage_helper.dart';

// ============================================================================
// STATES
// ============================================================================

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state - auth status unknown
class AuthInitial extends AuthState {}

/// Loading state for auth operations
class AuthLoading extends AuthState {}

/// Authentication successful
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

/// Authentication error
class AuthError extends AuthState {
  final String error;
  final bool canRetry;

  AuthError(this.error, {this.canRetry = true});

  @override
  List<Object?> get props => [error, canRetry];
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {}

// ============================================================================
// CUBIT
// ============================================================================

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final VerificationService _verificationService;
  final StorageHelper _storage;

  AuthCubit({
    AuthService? authService,
    VerificationService? verificationService,
    StorageHelper? storage,
  }) : _authService = authService ?? AuthService(),
       _verificationService = verificationService ?? VerificationService(),
       _storage = storage ?? StorageHelper(),
       super(AuthInitial());

  /// Register new user
  /// After successful registration, saves auth data and navigates to verification
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    try {
      emit(AuthLoading());

      final result = await _authService.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
      );

      result.when(
        success: (authResponse) async {
          // Save verification expiry
          final expiresAt = _verificationService.calculateExpiry();
          await _storage.saveVerificationExpiry(expiresAt);

          emit(
            AuthSuccess(
              user: authResponse.user,
              needsVerification: !authResponse.user.isVerified,
            ),
          );
        },
        failure: (error) {
          emit(AuthError(error.userMessage));
        },
      );
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  /// Login user
  /// After successful login, checks verification status and navigates accordingly
  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final result = await _authService.login(email: email, password: password);

      result.when(
        success: (authResponse) async {
          // Check if user needs email verification
          if (!authResponse.user.isVerified) {
            // Save verification expiry for countdown
            final expiry = _verificationService.calculateExpiry();
            await _storage.saveVerificationExpiry(expiry);

            emit(AuthSuccess(user: authResponse.user, needsVerification: true));
          } else {
            // User is verified, proceed normally
            emit(
              AuthSuccess(user: authResponse.user, needsVerification: false),
            );
          }
        },
        failure: (error) {
          emit(AuthError(error.userMessage));
        },
      );
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  /// Check authentication status on app startup
  /// Verifies token validity and user verification status
  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await _storage.isLoggedIn();

      if (!isLoggedIn) {
        emit(AuthUnauthenticated());
        return;
      }

      // Get current user from backend
      final result = await _authService.getCurrentUser();

      result.when(
        success: (user) {
          // Check verification status
          if (!user.isVerified) {
            // User logged in but not verified
            // This happens if user closed app during verification
            emit(AuthSuccess(user: user, needsVerification: true));
          } else {
            // Fully authenticated and verified
            emit(AuthSuccess(user: user, needsVerification: false));
          }
        },
        failure: (error) {
          // Token invalid or expired
          if (error.isAuthError) {
            // Clear invalid session
            _storage.clearAll();
            emit(AuthUnauthenticated());
          } else {
            // Network error - allow offline mode
            emit(AuthError(error.userMessage, canRetry: true));
          }
        },
      );
    } catch (e) {
      await _storage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  /// Logout user
  /// Clears all auth data and navigates to login
  Future<void> logout() async {
    try {
      await _authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Even if server logout fails, clear local data
      await _storage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  /// Update user data after email verification
  /// Called from VerifyCubit when verification succeeds
  Future<void> updateUserAfterVerification(UserModel user) async {
    try {
      // Refresh user data from backend to ensure it's up to date
      final result = await _authService.getCurrentUser();

      result.when(
        success: (freshUser) {
          emit(AuthSuccess(user: freshUser, needsVerification: false));
        },
        failure: (_) {
          // If fetch fails, use the provided user data
          emit(
            AuthSuccess(
              user: user.copyWith(isVerified: true),
              needsVerification: false,
            ),
          );
        },
      );
    } catch (e) {
      // Fallback: use provided user data
      emit(
        AuthSuccess(
          user: user.copyWith(isVerified: true),
          needsVerification: false,
        ),
      );
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      emit(AuthLoading());

      final result = await _authService.forgotPassword(email);

      result.when(
        success: (message) {
          // Return to unauthenticated state with success message
          // UI will show snackbar and navigate
          emit(AuthUnauthenticated());
        },
        failure: (error) {
          emit(AuthError(error.userMessage));
          // Return to unauthenticated after showing error
          Future.delayed(const Duration(seconds: 2), () {
            if (state is AuthError) {
              emit(AuthUnauthenticated());
            }
          });
        },
      );
    } catch (e) {
      emit(AuthError('Failed to send reset email: ${e.toString()}'));
    }
  }
}

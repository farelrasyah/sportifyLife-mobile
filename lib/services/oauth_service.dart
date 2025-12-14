import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import '../core/result.dart';
import '../data/models/auth_response_model.dart';
import '../data/models/user_model.dart';
import '../utils/storage_helper.dart';
import '../utils/constants.dart';

/// OAuth Service for Google and Facebook authentication
/// Handles deep linking and token management
class OAuthService {
  static final OAuthService _instance = OAuthService._internal();
  factory OAuthService() => _instance;
  OAuthService._internal();

  final StorageHelper _storage = StorageHelper();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // Completer to handle OAuth callback
  Completer<Result<AuthResponseModel>>? _oauthCompleter;

  /// Base URL for backend API
  static const String baseUrl = AppConstants.apiUrl;

  /// Initialize OAuth service and listen for deep links
  void initialize() {
    _listenToIncomingLinks();
  }

  /// Listen for incoming deep links from OAuth providers
  void _listenToIncomingLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('Received deep link: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
        if (_oauthCompleter != null && !_oauthCompleter!.isCompleted) {
          _oauthCompleter!.complete(
            Failure(ServiceError.unknown('Deep link error: $err')),
          );
        }
      },
    );
  }

  /// Handle deep link from OAuth callback
  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'sportifylife' &&
        uri.host == 'oauth' &&
        uri.path == '/callback') {
      final queryParams = uri.queryParameters;

      if (_oauthCompleter == null || _oauthCompleter!.isCompleted) {
        debugPrint('No active OAuth request to complete');
        return;
      }

      if (queryParams.containsKey('access_token')) {
        // Success response
        final accessToken = queryParams['access_token']!;
        final refreshToken = queryParams['refresh_token']!;
        final userId = queryParams['user_id']!;
        final provider = queryParams['provider']!;

        _handleOAuthSuccess(accessToken, refreshToken, userId, provider);
      } else if (queryParams.containsKey('error')) {
        // Error response
        final error = queryParams['error']!;
        final errorDescription = queryParams['error_description'];

        _handleOAuthError(error, errorDescription);
      } else {
        _oauthCompleter!.complete(
          Failure(ServiceError.unknown('Invalid OAuth callback')),
        );
      }
    }
  }

  /// Handle successful OAuth authentication
  void _handleOAuthSuccess(
    String accessToken,
    String refreshToken,
    String userId,
    String provider,
  ) async {
    try {
      // Save tokens to secure storage
      await _storage.saveAccessToken(accessToken);
      await _storage.saveRefreshToken(refreshToken);
      await _storage.saveUserId(userId);

      // Create user model (you'll need to fetch full user data from backend)
      // For now, create a basic user model
      final user = UserModel(
        id: userId,
        email: '', // Will be updated when fetching user profile
        firstName: '',
        lastName: '',
        provider: provider,
        isVerified: true, // OAuth users are automatically verified
      );

      final authResponse = AuthResponseModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
      );

      _oauthCompleter!.complete(Success(authResponse));

      debugPrint('OAuth success: $provider, user: $userId');
    } catch (e) {
      _oauthCompleter!.complete(
        Failure(ServiceError.unknown('Failed to save OAuth data: $e')),
      );
    }
  }

  /// Handle OAuth authentication error
  void _handleOAuthError(String error, String? description) {
    String errorMessage;

    switch (error) {
      case 'access_denied':
        errorMessage = 'User denied access to the application';
        break;
      case 'invalid_request':
        errorMessage = 'Invalid request';
        break;
      case 'unauthorized_client':
        errorMessage = 'Unauthorized client';
        break;
      case 'unsupported_response_type':
        errorMessage = 'Unsupported response type';
        break;
      case 'invalid_scope':
        errorMessage = 'Invalid scope';
        break;
      case 'server_error':
        errorMessage = 'Server error occurred';
        break;
      case 'temporarily_unavailable':
        errorMessage = 'Service temporarily unavailable';
        break;
      default:
        errorMessage = description ?? 'OAuth authentication failed';
    }

    _oauthCompleter!.complete(
      Failure(
        ServiceError.unknown(errorMessage),
      ), // Changed from ServiceError.authentication to ServiceError.unknown
    );

    debugPrint('OAuth error: $error - $description');
  }

  /// Initiate Google OAuth login
  Future<Result<AuthResponseModel>> loginWithGoogle() async {
    return _initiateOAuth('google');
  }

  /// Initiate Facebook OAuth login
  Future<Result<AuthResponseModel>> loginWithFacebook() async {
    return _initiateOAuth('facebook');
  }

  /// Generic OAuth initiation method
  Future<Result<AuthResponseModel>> _initiateOAuth(String provider) async {
    try {
      // Create a new completer for this OAuth request
      _oauthCompleter = Completer<Result<AuthResponseModel>>();

      // Construct OAuth URL
      final url = Uri.parse('$baseUrl/auth/$provider');

      // Launch OAuth URL
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );

      if (!launched) {
        _oauthCompleter!.complete(
          Failure(ServiceError.network('Could not launch OAuth URL')),
        );
      }

      // Wait for callback with timeout
      return await _oauthCompleter!.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          return Failure(ServiceError.unknown('OAuth authentication timeout'));
        },
      );
    } catch (e) {
      return Failure(ServiceError.unknown('OAuth initiation failed: $e'));
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    if (_oauthCompleter != null && !_oauthCompleter!.isCompleted) {
      _oauthCompleter!.complete(
        Failure(ServiceError.unknown('OAuth cancelled')),
      );
    }
  }
}

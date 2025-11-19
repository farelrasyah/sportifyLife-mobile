import '../core/result.dart';
import '../data/models/user_details_model.dart';
import 'http_service.dart';
import '../config/goal_type.dart';
import '../config/environment.dart';

/// Profile model for API requests
/// Only contains fields needed for complete profile endpoint
class ProfileModel {
  final double weight; // kg
  final int height; // cm
  final Gender gender;
  final DateTime dateOfBirth;
  final GoalType goalType;

  const ProfileModel({
    required this.weight,
    required this.height,
    required this.gender,
    required this.dateOfBirth,
    required this.goalType,
  });

  /// Validate profile data
  ValidationResult validate() {
    final errors = <String>[];

    // Validate weight
    if (weight < Environment.minWeight || weight > Environment.maxWeight) {
      errors.add(
        'Weight must be between ${Environment.minWeight} and ${Environment.maxWeight} kg',
      );
    }

    // Validate height
    if (height < Environment.minHeight || height > Environment.maxHeight) {
      errors.add(
        'Height must be between ${Environment.minHeight} and ${Environment.maxHeight} cm',
      );
    }

    // Validate age
    final age = _calculateAge(dateOfBirth);
    if (age < Environment.minAge || age > Environment.maxAge) {
      errors.add(
        'Age must be between ${Environment.minAge} and ${Environment.maxAge} years',
      );
    }

    // Validate date is not in future
    if (dateOfBirth.isAfter(DateTime.now())) {
      errors.add('Date of birth cannot be in the future');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Convert to JSON for API request
  /// Date format: YYYY-MM-DD (backend requirement)
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'gender': gender.value,
      'dateOfBirth': _formatDate(dateOfBirth),
      'goalType': goalType
          .value, // Send backend value (improve_shape, lean_tone, lose_fat)
    };
  }

  /// Format date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Calculate age from date of birth
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

/// Validation result
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({required this.isValid, required this.errors});

  String get errorMessage => errors.join('\n');
}

/// Profile Service
/// Handles all profile-related API calls
/// Endpoint: POST /api/v1/auth/complete-profile
class ProfileService {
  final HttpService _httpService;

  /// Constructor with dependency injection
  ProfileService({HttpService? httpService})
    : _httpService = httpService ?? HttpService();

  /// Complete user profile
  /// This is called after registration and email verification
  /// Returns success or ServiceError on failure
  /// Note: Backend returns {message: string}, not full user details
  Future<Result<void>> completeProfile(ProfileModel profile) async {
    // Validate input before making API call
    final validation = profile.validate();
    if (!validation.isValid) {
      return Failure(
        ServiceError.validation(
          'Invalid profile data',
          validationErrors: validation.errors,
        ),
      );
    }

    // Make API request - backend returns simple success message
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/complete-profile',
        data: profile.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (_) => const Success(null),
        failure: (error) => Failure(error),
      );
    } catch (e) {
      return Failure(ServiceError.unknown(e.toString()));
    }
  }

  /// Get user details
  /// Endpoint: GET /api/v1/user/details
  Future<Result<UserDetailsModel>> getUserDetails() async {
    return await _httpService.get<UserDetailsModel>(
      '/user/details',
      fromJson: (json) =>
          UserDetailsModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update user details (partial update)
  /// Endpoint: PUT /api/v1/user/details
  Future<Result<UserDetailsModel>> updateUserDetails({
    double? weight,
    int? height,
    Gender? gender,
    DateTime? dateOfBirth,
    GoalType? goalType,
  }) async {
    final Map<String, dynamic> data = {};

    if (weight != null) data['weight'] = weight;
    if (height != null) data['height'] = height;
    if (gender != null) data['gender'] = gender.value;
    if (dateOfBirth != null) {
      data['dateOfBirth'] =
          '${dateOfBirth.year.toString().padLeft(4, '0')}-'
          '${dateOfBirth.month.toString().padLeft(2, '0')}-'
          '${dateOfBirth.day.toString().padLeft(2, '0')}';
    }
    if (goalType != null) data['goalType'] = goalType.value;

    return await _httpService.put<UserDetailsModel>(
      '/user/details',
      data: data,
      fromJson: (json) =>
          UserDetailsModel.fromJson(json as Map<String, dynamic>),
    );
  }
}

import '../models/userDetailsModel.dart';
import '../../services/profile_service.dart';
import '../../config/goal_type.dart';

/// User details repository for API calls
/// This is a wrapper around ProfileService for backward compatibility
class UserDetailsRepository {
  final ProfileService _profileService;

  UserDetailsRepository({ProfileService? profileService})
    : _profileService = profileService ?? ProfileService();

  /// Get user details
  Future<UserDetailsModel?> getUserDetails() async {
    final result = await _profileService.getUserDetails();

    return result.when(
      success: (data) => data,
      failure: (error) {
        // If 404, user details don't exist yet
        if (error.statusCode == 404) {
          return null;
        }
        throw Exception(error.userMessage);
      },
    );
  }

  /// Complete user profile (first time)
  /// Calls POST /api/v1/auth/complete-profile
  /// Requires: gender, dateOfBirth (YYYY-MM-DD), weight, height, goalType
  Future<UserDetailsModel> completeProfile({
    required double weight,
    required int height,
    required Gender gender,
    required DateTime dateOfBirth,
    required GoalType goalType,
  }) async {
    // Create profile model
    final profile = ProfileModel(
      weight: weight,
      height: height,
      gender: gender,
      dateOfBirth: dateOfBirth,
      goalType: goalType,
    );

    // Call service
    final result = await _profileService.completeProfile(profile);

    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  /// Update user details
  Future<UserDetailsModel> updateUserDetails({
    double? weight,
    int? height,
    Gender? gender,
    DateTime? dateOfBirth,
    GoalType? goalType,
  }) async {
    final result = await _profileService.updateUserDetails(
      weight: weight,
      height: height,
      gender: gender,
      dateOfBirth: dateOfBirth,
      goalType: goalType,
    );

    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }
}

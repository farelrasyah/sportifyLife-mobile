import '../../utils/api_client.dart';
import '../../utils/api.dart';
import '../models/profile_models.dart';

/// Repository for user profile related operations
class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  /// Complete user profile
  Future<void> completeProfile(CompleteProfileRequest request) async {
    try {
      final response = await _apiClient.postRequest(
        Api.completeProfile,
        data: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to complete profile: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Complete profile failed: $e');
    }
  }

  /// Post user goal
  Future<void> postGoal(GoalRequest request) async {
    try {
      final response = await _apiClient.postRequest(
        Api.postGoal,
        data: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to post goal: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Post goal failed: $e');
    }
  }
}

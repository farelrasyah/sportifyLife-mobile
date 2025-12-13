/// Request model for completing user profile
class CompleteProfileRequest {
  final String gender;
  final String dateOfBirth;
  final double weight;
  final double height;

  CompleteProfileRequest({
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'weight': weight,
      'height': height,
    };
  }
}

/// Request model for setting user goal
class GoalRequest {
  final String goalType;

  GoalRequest({required this.goalType});

  Map<String, dynamic> toJson() {
    return {'goalType': goalType};
  }
}

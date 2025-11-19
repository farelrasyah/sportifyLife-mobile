import 'package:equatable/equatable.dart';
import '../../config/goal_type.dart';

/// User details model (weight, height, goal type)
/// Matches backend schema: gender, dateOfBirth, weight, height, goalType
/// Backend allowed goalType values: improve_shape, lean_tone, lose_fat
class UserDetailsModel extends Equatable {
  final String id;
  final String userId;
  final double? weight; // in kg
  final int? height; // in cm
  final Gender? gender; // male, female, other
  final DateTime? dateOfBirth;
  final GoalType? goalType; // improve_shape, lean_tone, lose_fat
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserDetailsModel({
    required this.id,
    required this.userId,
    this.weight,
    this.height,
    this.gender,
    this.dateOfBirth,
    this.goalType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    // Parse gender from string to enum
    Gender? parsedGender;
    final genderStr = json['gender'] as String?;
    if (genderStr != null) {
      parsedGender = Gender.fromValue(genderStr);
    }

    // Parse goalType from string to enum
    GoalType? parsedGoalType;
    final goalTypeStr = json['goalType'] as String?;
    if (goalTypeStr != null) {
      parsedGoalType = GoalType.fromValue(goalTypeStr);
    }

    return UserDetailsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      height: json['height'] as int?,
      gender: parsedGender,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      goalType: parsedGoalType,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON for API requests
  /// dateOfBirth is formatted as YYYY-MM-DD string
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'gender': gender?.value,
      'dateOfBirth': dateOfBirth != null
          ? '${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}'
          : null,
      'goalType': goalType?.value,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  UserDetailsModel copyWith({
    String? id,
    String? userId,
    double? weight,
    int? height,
    Gender? gender,
    DateTime? dateOfBirth,
    GoalType? goalType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      goalType: goalType ?? this.goalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if profile is complete (all required fields filled)
  bool get isComplete {
    return weight != null &&
        height != null &&
        gender != null &&
        dateOfBirth != null &&
        goalType != null;
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Calculate BMI (Body Mass Index)
  double? get bmi {
    if (weight == null || height == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;

    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    weight,
    height,
    gender,
    dateOfBirth,
    goalType,
    createdAt,
    updatedAt,
  ];
}

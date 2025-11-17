import 'package:equatable/equatable.dart';

/// User details model (weight, height, etc)
class UserDetailsModel extends Equatable {
  final String id;
  final String userId;
  final double? weight; // in kg
  final int? height; // in cm
  final String? gender; // male, female, other
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDetailsModel({
    required this.id,
    required this.userId,
    this.weight,
    this.height,
    this.gender,
    this.dateOfBirth,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      height: json['height'] as int?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserDetailsModel copyWith({
    String? id,
    String? userId,
    double? weight,
    int? height,
    String? gender,
    DateTime? dateOfBirth,
    String? phoneNumber,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if profile is complete
  bool get isComplete {
    return weight != null &&
        height != null &&
        gender != null &&
        dateOfBirth != null &&
        phoneNumber != null &&
        phoneNumber!.isNotEmpty;
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
    phoneNumber,
    createdAt,
    updatedAt,
  ];
}

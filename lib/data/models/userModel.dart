import 'package:equatable/equatable.dart';

/// User model
class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String provider;
  final bool isVerified;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.provider,
    this.isVerified = false,
    this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      provider: json['provider'] as String? ?? 'local',
      isVerified: json['isVerified'] as bool? ?? false,
      profilePhoto: json['profilePhoto'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'provider': provider,
      'isVerified': isVerified,
      'profilePhoto': profilePhoto,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? provider,
    bool? isVerified,
    String? profilePhoto,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      provider: provider ?? this.provider,
      isVerified: isVerified ?? this.isVerified,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    provider,
    isVerified,
    profilePhoto,
    createdAt,
    updatedAt,
  ];
}

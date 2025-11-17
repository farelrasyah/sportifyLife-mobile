import 'package:equatable/equatable.dart';
import 'userModel.dart';

/// Auth response model
class AuthResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponseModel(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'user': user.toJson(),
      },
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}

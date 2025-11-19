import 'package:equatable/equatable.dart';
import 'user_model.dart';

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
    // HttpService._extractData already extracts 'data' field
    // So json already contains: {accessToken, refreshToken, user}
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
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

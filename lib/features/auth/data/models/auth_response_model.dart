import 'package:ride_hail/features/auth/data/models/user_model.dart';

abstract interface class AuthResponse {
  UserModel get user;
  String get token;
}

class AuthResponseImpl implements AuthResponse {
  @override
  final UserModel user;
  @override
  final String token;

  const AuthResponseImpl({required this.token, required this.user});

  factory AuthResponseImpl.fromJson(String responseBody, String token) {
    return AuthResponseImpl(
      user: UserModel.fromJson(responseBody),
      token: token,
    );
  }
}

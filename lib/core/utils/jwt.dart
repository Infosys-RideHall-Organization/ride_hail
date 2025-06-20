import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

bool isTokenExpired(String token) {
  final decodedToken = JwtDecoder.tryDecode(token);
  if (decodedToken != null) {
    debugPrint('JWT Token = ${decodedToken.toString()}');
  }
  return JwtDecoder.isExpired(token);
}

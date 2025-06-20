import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> signInWithGoogle({required String idToken});

  Future<UserModel> emailVerification({required String verificationToken});

  Future<String> forgotPasswordWithEmail({required String email});

  Future<String> resetPasswordVerification({
    required String resetPasswordToken,
  });

  Future<String> resetPassword({
    required String password,
    required String resetPasswordToken,
  });

  Future<String> resetPasswordWithId({
    required String password,
    required String userId,
  });

  Future<UserModel> getCurrentUser({required String token});
  Future<bool> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      debugPrint(response.body);
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.body);
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      debugPrint(response.headers['x-auth-token']);
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return AuthResponseImpl.fromJson(
          response.body,
          response.headers['x-auth-token']!,
        );
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> signInWithGoogle({required String idToken}) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/google-sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      debugPrint(response.headers['x-auth-token']);
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return AuthResponseImpl.fromJson(
          response.body,
          response.headers['x-auth-token']!,
        );
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> emailVerification({
    required String verificationToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/verify-email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"verificationToken": verificationToken}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.body);
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> forgotPasswordWithEmail({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/forgot-password'),
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resetPasswordVerification({
    required String resetPasswordToken,
  }) async {
    try {
      //
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/verify-reset-token'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"resetPasswordToken": resetPasswordToken}),
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resetPassword({
    required String password,
    required String resetPasswordToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/reset-password'),
        body: jsonEncode({
          "password": password,
          "resetPasswordToken": resetPasswordToken,
        }),
        headers: {"Content-Type": "application/json"},
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resetPasswordWithId({
    required String password,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/reset-password/$userId'),
        body: jsonEncode({"password": password}),
        headers: {"Content-Type": "application/json"},
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw ServerException(message: jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse(('${Constants.backendUrl}/auth/check-auth')),
        headers: {'x-auth-token': token},
      );

      //debugPrint("From current user = "+response.body);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.body);
      }
      throw ServerException(message: jsonDecode(response.body)['error']);
    } catch (e) {
      debugPrint(e.toString());
      //debugPrintStack();
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final response = await http.get(
        Uri.parse(('${Constants.backendUrl}/auth/sign-out')),
      );

      //debugPrint("From current user = "+response.body);

      if (response.statusCode == 200) {
        return true;
      }
      throw ServerException(message: jsonDecode(response.body)['error']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/entities/auth/user.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/jwt.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
  });
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final User user = await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      // Save the token
      await authLocalDataSource.saveToken(Constants.jwtKey, authResponse.token);
      final savedToken = await authLocalDataSource.getToken(Constants.jwtKey);
      debugPrint("Saved Token: $savedToken");
      // Save user id
      await authLocalDataSource.saveUserId(
        Constants.userIdKey,
        authResponse.user.id,
      );
      final savedUserId = await authLocalDataSource.getToken(
        Constants.userIdKey,
      );
      debugPrint("Saved User Id: $savedUserId");
      return right(authResponse.user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle({
    required String idToken,
  }) async {
    try {
      final authResponse = await authRemoteDataSource.signInWithGoogle(
        idToken: idToken,
      );
      // Save the token
      await authLocalDataSource.saveToken(Constants.jwtKey, authResponse.token);
      final savedToken = await authLocalDataSource.getToken(Constants.jwtKey);
      debugPrint("Saved Token: $savedToken");
      // Save user id
      await authLocalDataSource.saveUserId(
        Constants.userIdKey,
        authResponse.user.id,
      );
      final savedUserId = await authLocalDataSource.getToken(
        Constants.userIdKey,
      );
      debugPrint("Saved User Id: $savedUserId");
      return right(authResponse.user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> emailVerification({
    required String verificationToken,
  }) async {
    try {
      final User user = await authRemoteDataSource.emailVerification(
        verificationToken: verificationToken,
      );
      return right(user);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPasswordWithEmail({
    required String email,
  }) async {
    try {
      final String message = await authRemoteDataSource.forgotPasswordWithEmail(
        email: email,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resetPasswordVerification({
    required String resetPasswordToken,
  }) async {
    try {
      final message = await authRemoteDataSource.resetPasswordVerification(
        resetPasswordToken: resetPasswordToken,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String password,
    required String resetPasswordToken,
  }) async {
    try {
      final message = await authRemoteDataSource.resetPassword(
        password: password,
        resetPasswordToken: resetPasswordToken,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resetPasswordWithId({
    required String password,
  }) async {
    try {
      final userId = await authLocalDataSource.getUserId(Constants.userIdKey);
      if (userId == null) {
        return left(Failure('Failed to retrieve credentials'));
      }
      final message = await authRemoteDataSource.resetPasswordWithId(
        password: password,
        userId: userId,
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      String jwtKey = Constants.jwtKey;
      String userIdKey = Constants.userIdKey;
      final savedToken = await authLocalDataSource.getToken(jwtKey);
      debugPrint('Saved token = $savedToken');
      if (savedToken == null) {
        return left(Failure('No token saved.'));
      } else if (isTokenExpired(savedToken)) {
        await authLocalDataSource.deleteToken(jwtKey);
        await authLocalDataSource.deleteUserId(userIdKey);
        return left(Failure('Session expired, please login again.'));
      }
      final user = await authRemoteDataSource.getCurrentUser(token: savedToken);
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      String jwtKey = Constants.jwtKey;
      String userIdKey = Constants.userIdKey;
      final savedToken = await authLocalDataSource.getToken(jwtKey);
      debugPrint('Saved token = $savedToken');
      final savedUserId = await authLocalDataSource.getUserId(userIdKey);
      debugPrint('Saved User Id = $savedUserId');
      if (savedToken == null) {
        return left(Failure('No token saved.'));
      }
      await authLocalDataSource.deleteToken(jwtKey);
      await authLocalDataSource.deleteUserId(userIdKey);
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_hail/core/constants/constants.dart';
import 'package:ride_hail/core/error/failure.dart';
import 'package:ride_hail/core/services/secure_storage/secure_storage_service.dart';
import 'package:ride_hail/features/profile/data/models/profile_model.dart';
import 'package:ride_hail/features/profile/domain/entities/profile.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final SecureStorageService secureStorageService;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.secureStorageService,
  });
  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final tokenExists = await secureStorageService.containsKey(
        Constants.jwtKey,
      );
      final userIdExists = await secureStorageService.containsKey(
        Constants.userIdKey,
      );

      if (!tokenExists || !userIdExists) {
        return left(Failure('Missing authentication data'));
      }

      final token = await secureStorageService.getString(Constants.jwtKey);
      final userId = await secureStorageService.getString(Constants.userIdKey);

      if (token == null || userId == null) {
        return left(Failure('Failed to retrieve credentials'));
      }

      final profile = await profileRemoteDataSource.getProfile(
        token: token,
        userId: userId,
      );

      return right(profile);
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return left(Failure(e.message));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return left(Failure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile({
    required String name,
    required String gender,
    required File? imageFile,
  }) async {
    try {
      final tokenExists = await secureStorageService.containsKey(
        Constants.jwtKey,
      );
      final userIdExists = await secureStorageService.containsKey(
        Constants.userIdKey,
      );

      if (!tokenExists || !userIdExists) {
        return left(Failure('Missing authentication data'));
      }

      final token = await secureStorageService.getString(Constants.jwtKey);
      final userId = await secureStorageService.getString(Constants.userIdKey);

      if (token == null || userId == null) {
        return left(Failure('Failed to retrieve credentials'));
      }

      final profile = await profileRemoteDataSource.updateProfile(
        imageFile: imageFile,
        name: name,
        gender: gender,
        token: token,
        userId: userId,
      );
      return right(profile);
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return left(Failure(e.message));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return left(Failure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, Profile>> deleteProfile() async {
    try {
      final tokenExists = await secureStorageService.containsKey(
        Constants.jwtKey,
      );
      final userIdExists = await secureStorageService.containsKey(
        Constants.userIdKey,
      );

      if (!tokenExists || !userIdExists) {
        return left(Failure('Missing authentication data'));
      }

      final token = await secureStorageService.getString(Constants.jwtKey);
      final userId = await secureStorageService.getString(Constants.userIdKey);

      if (token == null || userId == null) {
        return left(Failure('Failed to retrieve credentials'));
      }

      final profile = await profileRemoteDataSource.deleteProfile(
        token: token,
        userId: userId,
      );
      secureStorageService.deleteString(Constants.userIdKey);
      secureStorageService.deleteString(Constants.jwtKey);
      return right(profile);
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return left(Failure(e.message));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return left(Failure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, Profile>> updatePlayerId({
    required String playerId,
  }) async {
    try {
      final userId = await secureStorageService.getString(Constants.userIdKey);
      final message = await profileRemoteDataSource.updatePlayerId(
        playerId: playerId,
        userId: userId ?? '',
      );
      return right(message);
    } on ServerException catch (e) {
      debugPrint(e.message);
      return left(Failure(e.message));
    }
  }
}

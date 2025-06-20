import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();

  Future<Either<Failure, Profile>> updateProfile({
    required String name,
    required String gender,
    required File? imageFile,
  });

  Future<Either<Failure, Profile>> deleteProfile();

  Future<Either<Failure, Profile>> updatePlayerId({required String playerId});
}

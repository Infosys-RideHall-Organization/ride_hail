import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUsecase implements Usecase<Profile, UpdateProfileParams> {
  final ProfileRepository profileRepository;

  const UpdateProfileUsecase({required this.profileRepository});

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) async {
    return await profileRepository.updateProfile(
      name: params.name,
      gender: params.gender,
      imageFile: params.imageFile,
    );
  }
}

class UpdateProfileParams {
  final String name;
  final String gender;
  final File? imageFile;

  const UpdateProfileParams({
    required this.name,
    required this.gender,
    required this.imageFile,
  });
}

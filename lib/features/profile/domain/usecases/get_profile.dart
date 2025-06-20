import 'package:fpdart/fpdart.dart';
import 'package:ride_hail/features/profile/domain/entities/profile.dart';
import 'package:ride_hail/features/profile/domain/repositories/profile_repository.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';

class GetProfileUsecase implements Usecase<Profile, NoParams> {
  final ProfileRepository profileRepository;

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await profileRepository.getProfile();
  }

  const GetProfileUsecase({required this.profileRepository});
}

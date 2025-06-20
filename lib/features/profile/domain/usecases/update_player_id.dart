import 'package:fpdart/fpdart.dart';
import 'package:ride_hail/features/profile/domain/entities/profile.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class UpdatePlayerIdUseCase implements Usecase<Profile, UpdatePlayerIdParams> {
  final ProfileRepository profileRepository;

  @override
  Future<Either<Failure, Profile>> call(UpdatePlayerIdParams params) async {
    return await profileRepository.updatePlayerId(playerId: params.playerId);
  }

  const UpdatePlayerIdUseCase({required this.profileRepository});
}

class UpdatePlayerIdParams {
  String playerId;
  UpdatePlayerIdParams({required this.playerId});
}

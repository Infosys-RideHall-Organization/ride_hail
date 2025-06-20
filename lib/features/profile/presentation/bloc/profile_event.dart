part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfile extends ProfileEvent {}

class DeleteProfile extends ProfileEvent {}

// class UploadProfileImage extends ProfileEvent {
//   final File imageFile;
//   UploadProfileImage(this.imageFile);
// }

final class UpdatePlayerId extends ProfileEvent {
  final String playerId;

  UpdatePlayerId({required this.playerId});
}

class UpdateProfileDetails extends ProfileEvent {
  final String name;
  final String gender;
  final File? file;
  UpdateProfileDetails({this.file, required this.name, required this.gender});
}

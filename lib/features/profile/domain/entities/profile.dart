import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String? profileImage; // nullable
  final String name;
  final String email;
  final String gender;

  final String? playerId;

  const Profile({
    required this.id,
    this.profileImage,
    this.playerId,
    required this.name,
    required this.email,
    required this.gender,
  });

  factory Profile.initial() {
    return Profile(id: '-1', name: '', email: '', gender: 'Not Specified');
  }

  Profile copyWith({
    String? id,
    String? profileImage,
    String? name,
    String? email,
    String? gender,
    String? playerId,
  }) {
    return Profile(
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      playerId: playerId ?? this.playerId,
    );
  }

  @override
  List<Object?> get props => [id, profileImage, name, email, gender, playerId];

  @override
  String toString() {
    return 'Profile{id: $id, profileImage: $profileImage, name: $name, email: $email, gender: $gender, playerId: $playerId}';
  }
}

import 'dart:convert';

import 'package:ride_hail/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    super.profileImage,
    super.playerId,
    required super.name,
    required super.email,
    required super.gender,
  });

  factory ProfileModel.fromJson(String json) {
    return ProfileModel.fromMap(jsonDecode(json));
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['_id'],
      profileImage: map['imageUrl'],
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      playerId: map['playerId'],
    );
  }
}

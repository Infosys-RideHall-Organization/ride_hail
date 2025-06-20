import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final Map<String, dynamic>? profileImage; // nullable
  final String name;
  final String email;
  final String gender;

  final String? playerId;
  final String role;
  final DateTime? lastLogin;
  final bool isVerified;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpiresAt;
  final bool isResetVerified;
  final String? verificationToken;
  final DateTime? verificationTokenExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    this.profileImage,
    required this.name,
    required this.email,
    required this.gender,
    required this.role,
    this.lastLogin,
    this.playerId,
    required this.isVerified,
    this.resetPasswordToken,
    this.resetPasswordExpiresAt,
    required this.isResetVerified,
    this.verificationToken,
    this.verificationTokenExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.initial() {
    return User(
      id: '-1',
      profileImage: null,
      name: '',
      email: '',
      gender: '',
      role: '',
      isVerified: false,
      isResetVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  User copyWith({
    String? id,
    Map<String, dynamic>? profileImage,
    String? name,
    String? email,
    String? gender,
    String? role,
    String? playerId,
    DateTime? lastLogin,
    bool? isVerified,
    String? resetPasswordToken,
    DateTime? resetPasswordExpiresAt,
    bool? isResetVerified,
    String? verificationToken,
    DateTime? verificationTokenExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      playerId: playerId ?? this.playerId,
      lastLogin: lastLogin ?? this.lastLogin,
      isVerified: isVerified ?? this.isVerified,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordExpiresAt:
          resetPasswordExpiresAt ?? this.resetPasswordExpiresAt,
      isResetVerified: isResetVerified ?? this.isResetVerified,
      verificationToken: verificationToken ?? this.verificationToken,
      verificationTokenExpiresAt:
          verificationTokenExpiresAt ?? this.verificationTokenExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    profileImage,
    name,
    email,
    gender,
    role,
    lastLogin,
    isVerified,
    resetPasswordToken,
    resetPasswordExpiresAt,
    isResetVerified,
    verificationToken,
    verificationTokenExpiresAt,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'User{id: $id, imageUrl: $profileImage, name: $name, email: $email, gender: $gender, role:$role, lastLogin: $lastLogin, isVerified: $isVerified, resetPasswordToken: $resetPasswordToken, resetPasswordExpiresAt: $resetPasswordExpiresAt, isResetVerified: $isResetVerified, verificationToken: $verificationToken, verificationTokenExpiresAt: $verificationTokenExpiresAt, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

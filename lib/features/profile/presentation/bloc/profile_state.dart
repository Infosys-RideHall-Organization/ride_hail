part of 'profile_bloc.dart';

final class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];

  const ProfileState();
}

final class ProfileLoading extends ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final Profile profile;

  const ProfileSuccess({required this.profile});

  ProfileSuccess copyWith({Profile? profile}) {
    return ProfileSuccess(profile: profile ?? this.profile);
  }

  @override
  List<Object> get props => [profile];

  @override
  String toString() {
    return 'ProfileSuccess{profile: $profile}';
  }
}

final class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure({required this.message});
}

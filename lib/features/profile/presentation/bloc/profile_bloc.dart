import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ride_hail/core/usecase/usecase.dart';
import 'package:ride_hail/features/profile/domain/usecases/get_profile.dart';
import 'package:ride_hail/features/profile/domain/usecases/update_player_id.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/delete_profile.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final DeleteProfileUsecase _deleteProfileUsecase;

  final UpdatePlayerIdUseCase _updatePlayerIdUseCase;
  ProfileBloc({
    required AppUserCubit appUserCubit,
    required GetProfileUsecase getProfileUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
    required DeleteProfileUsecase deleteProfileUsecase,
    required UpdatePlayerIdUseCase updatePlayerIdUseCase,
  }) : _getProfileUsecase = getProfileUsecase,
       _updateProfileUsecase = updateProfileUsecase,
       _deleteProfileUsecase = deleteProfileUsecase,
       _updatePlayerIdUseCase = updatePlayerIdUseCase,
       _appUserCubit = appUserCubit,
       super(ProfileInitial()) {
    // on<ProfileEvent>((event, emit) {});

    on<GetProfile>((event, emit) async {
      emit(ProfileLoading());
      final response = await _getProfileUsecase.call(NoParams());
      response.fold(
        (failure) => emit(ProfileFailure(message: failure.message)),
        (profile) => emit(ProfileSuccess(profile: profile)),
      );
    });

    on<UpdateProfileDetails>((event, emit) async {
      emit(ProfileLoading());
      final response = await _updateProfileUsecase.call(
        UpdateProfileParams(
          name: event.name,
          gender: event.gender,
          imageFile: event.file,
        ),
      );
      response.fold(
        (failure) => emit(ProfileFailure(message: failure.message)),
        (profile) => emit(ProfileSuccess(profile: profile)),
      );
    });

    on<UpdatePlayerId>((event, emit) async {
      emit(ProfileLoading());
      final response = await _updatePlayerIdUseCase(
        UpdatePlayerIdParams(playerId: event.playerId),
      );
      response.fold(
        (failure) => null,
        (profile) => emit(ProfileSuccess(profile: profile)),
      );
    });

    on<DeleteProfile>((event, emit) async {
      emit(ProfileLoading());
      final response = await _deleteProfileUsecase.call(NoParams());
      response.fold(
        (failure) => emit(ProfileFailure(message: failure.message)),
        (_) {
          _appUserCubit.updateUserStatus(null);
          emit(ProfileInitial());
        },
      );
    });
  }
}

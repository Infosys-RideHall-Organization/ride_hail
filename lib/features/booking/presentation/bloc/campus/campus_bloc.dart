import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ride_hail/core/usecase/usecase.dart';

import '../../../domain/entities/campus/campus.dart';
import '../../../domain/usecases/campus/get_all_campuses.dart';

part 'campus_event.dart';
part 'campus_state.dart';

class CampusBloc extends Bloc<CampusEvent, CampusState> {
  final GetCampusesUsecase _getAllCampuses;

  CampusBloc({required GetCampusesUsecase getAllCampuses})
    : _getAllCampuses = getAllCampuses,
      super(CampusInitial()) {
    on<LoadCampuses>(_onLoadCampuses);
  }

  Future<void> _onLoadCampuses(
    LoadCampuses event,
    Emitter<CampusState> emit,
  ) async {
    emit(CampusLoading());
    final result = await _getAllCampuses(NoParams());

    result.fold(
      (failure) => emit(CampusFailure(message: failure.message)),
      (campuses) => emit(CampusLoaded(campuses: campuses)),
    );
  }
}

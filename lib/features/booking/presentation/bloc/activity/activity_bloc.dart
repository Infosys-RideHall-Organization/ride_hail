import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/core/usecase/usecase.dart';

import '../../../domain/entities/booking/booking.dart';
import '../../../domain/usecases/activity/get_past_bookings.dart';
import '../../../domain/usecases/activity/get_upcoming_bookings.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetPastBookingsUsecase _getPastBookingsUsecase;
  final GetUpcomingBookingsUsecase _getUpcomingBookingsUsecase;

  ActivityBloc({
    required GetPastBookingsUsecase getPastBookingsUsecase,
    required GetUpcomingBookingsUsecase getUpcomingBookingsUsecase,
  }) : _getPastBookingsUsecase = getPastBookingsUsecase,
       _getUpcomingBookingsUsecase = getUpcomingBookingsUsecase,
       super(ActivityInitial()) {
    on<GetPastBookings>((event, emit) async {
      emit(ActivityLoading());
      final result = await _getPastBookingsUsecase(NoParams());
      result.fold(
        (failure) => emit(ActivityError(message: failure.message)),
        (pastBookings) => emit(
          ActivityLoaded(
            pastBookings: pastBookings,
            upcomingBookings: state.upcomingBookings,
          ),
        ),
      );
    });

    on<GetUpcomingBookings>((event, emit) async {
      emit(ActivityLoading());
      final result = await _getUpcomingBookingsUsecase(NoParams());
      result.fold(
        (failure) => emit(ActivityError(message: failure.message)),
        (upcomingBookings) => emit(
          ActivityLoaded(
            pastBookings: state.pastBookings,
            upcomingBookings: upcomingBookings,
          ),
        ),
      );
    });
  }
}

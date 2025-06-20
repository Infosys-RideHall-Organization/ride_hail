// Create the cubit
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'booking_stage_state.dart';

class BookingStageCubit extends Cubit<BookingStageState> {
  BookingStageCubit()
    : super(BookingStageState(stage: BookingStage.selectDestination));

  void setStage(BookingStage stage) {
    emit(state.copyWith(stage: stage));
  }

  void nextStage() {
    switch (state.stage) {
      case BookingStage.selectDestination:
        emit(state.copyWith(stage: BookingStage.confirmPickup));
        break;
      case BookingStage.confirmPickup:
        emit(state.copyWith(stage: BookingStage.yourTrip));
        break;
      case BookingStage.yourTrip:
        emit(state.copyWith(stage: BookingStage.addPassengers));
        break;
      case BookingStage.addPassengers:
        emit(state.copyWith(stage: BookingStage.scheduleTrip));
        break;
      case BookingStage.scheduleTrip:
        emit(state.copyWith(stage: BookingStage.bookingConfirmed));
        break;
      case BookingStage.bookingConfirmed:
        emit(state.copyWith(stage: BookingStage.assignVehicle));
        break;
      case BookingStage.assignVehicle:
        emit(state.copyWith(stage: BookingStage.enRoute));
        break;
      case BookingStage.enRoute:
        // Final stage, do nothing
        break;
    }
  }

  void previousStage() {
    switch (state.stage) {
      case BookingStage.selectDestination:
        // First stage, do nothing
        break;
      case BookingStage.confirmPickup:
        emit(state.copyWith(stage: BookingStage.selectDestination));
        break;
      case BookingStage.yourTrip:
        emit(state.copyWith(stage: BookingStage.confirmPickup));
        break;
      case BookingStage.addPassengers:
        emit(state.copyWith(stage: BookingStage.yourTrip));
        break;
      case BookingStage.scheduleTrip:
        emit(state.copyWith(stage: BookingStage.addPassengers));
        break;
      case BookingStage.bookingConfirmed:
        emit(state.copyWith(stage: BookingStage.scheduleTrip));
        break;
      case BookingStage.assignVehicle:
        emit(state.copyWith(stage: BookingStage.scheduleTrip));
        break;
      case BookingStage.enRoute:
        emit(state.copyWith(stage: BookingStage.scheduleTrip));
        break;
    }
  }

  void reset() {
    emit(BookingStageState(stage: BookingStage.selectDestination));
  }
}

// Define the stages enum
part of 'booking_stage_cubit.dart';

enum BookingStage {
  selectDestination,
  confirmPickup,
  yourTrip,
  addPassengers,
  scheduleTrip,
  bookingConfirmed,
  assignVehicle,
  enRoute,
}

// Define the cubit state
class BookingStageState extends Equatable {
  final BookingStage stage;

  const BookingStageState({required this.stage});

  BookingStageState copyWith({BookingStage? stage}) {
    return BookingStageState(stage: stage ?? this.stage);
  }

  @override
  List<Object?> get props => [stage];
}

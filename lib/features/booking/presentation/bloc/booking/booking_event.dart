part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();
}

class UpdateOriginAndAddress extends BookingEvent {
  final LatLng origin;
  final String originAddress;

  const UpdateOriginAndAddress(this.origin, this.originAddress);

  @override
  List<Object?> get props => [origin, originAddress];
}

class UpdateDestinationAndAddress extends BookingEvent {
  final LatLng destination;
  final String destinationAddress;

  const UpdateDestinationAndAddress(this.destination, this.destinationAddress);

  @override
  List<Object?> get props => [destination, destinationAddress];
}

class UpdateCampusSelected extends BookingEvent {
  final Campus campus;

  const UpdateCampusSelected(this.campus);

  @override
  List<Object?> get props => [campus];
}

class UpdateVehicleType extends BookingEvent {
  final String vehicleType;

  const UpdateVehicleType(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}

class UpdatePassengers extends BookingEvent {
  final List<Passenger> passengers;

  const UpdatePassengers(this.passengers);

  @override
  List<Object?> get props => [passengers];
}

class UpdateWeights extends BookingEvent {
  final List<WeightItem> weightItems;

  const UpdateWeights(this.weightItems);

  @override
  List<Object?> get props => [weightItems];
}

class UpdateSchedule extends BookingEvent {
  final DateTime schedule;

  const UpdateSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class GetBookingByIdEvent extends BookingEvent {
  final String bookingId;

  const GetBookingByIdEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class SubmitBooking extends BookingEvent {
  const SubmitBooking();

  @override
  List<Object?> get props => [];
}

class PollBookingStatus extends BookingEvent {
  final String bookingId;

  const PollBookingStatus(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class VerifyOtp extends BookingEvent {
  final String otp;

  const VerifyOtp(this.otp);

  @override
  List<Object?> get props => [otp];
}

class CancelBooking extends BookingEvent {
  const CancelBooking();

  @override
  List<Object?> get props => [];
}

class EmergencyStop extends BookingEvent {
  final String reason;
  const EmergencyStop({required this.reason});

  @override
  List<Object?> get props => [reason];
}

class CompleteBooking extends BookingEvent {
  const CompleteBooking();

  @override
  List<Object?> get props => [];
}

class ResetBooking extends BookingEvent {
  const ResetBooking();

  @override
  List<Object?> get props => [];
}

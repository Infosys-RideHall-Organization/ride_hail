part of 'booking_bloc.dart';

class BookingState extends Equatable {
  final LatLng? origin;
  final Campus? campus;
  final String? originAddress;
  final LatLng? destination;
  final String? destinationAddress;
  final String? vehicleType;
  final List<Passenger> passengers;
  final List<WeightItem> weightItems;
  final DateTime? schedule;
  final bool loading;
  final String? errorMessage;

  final Booking? booking;

  const BookingState({
    this.origin,
    this.originAddress,
    this.destination,
    this.destinationAddress,
    this.vehicleType,
    this.passengers = const [],
    this.weightItems = const [],
    this.schedule,
    this.loading = false,
    this.errorMessage,
    this.booking,
    this.campus,
  });

  BookingState copyWith({
    LatLng? origin,
    String? originAddress,
    LatLng? destination,
    String? destinationAddress,
    String? vehicleType,
    List<Passenger>? passengers,
    List<WeightItem>? weightItems,
    DateTime? schedule,
    bool? loading,
    String? errorMessage,
    Booking? booking,
    Campus? campus,
  }) {
    return BookingState(
      origin: origin ?? this.origin,
      originAddress: originAddress ?? this.originAddress,
      destination: destination ?? this.destination,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      vehicleType: vehicleType ?? this.vehicleType,
      passengers: passengers ?? this.passengers,
      weightItems: weightItems ?? this.weightItems,
      schedule: schedule ?? this.schedule,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      booking: booking ?? this.booking,
      campus: campus ?? this.campus,
    );
  }

  BookingState clearSessionData() {
    return BookingState(
      vehicleType: vehicleType,
      campus: campus,
      loading: false,
      booking: null,
      passengers: const [],
      weightItems: const [],
    );
  }

  @override
  List<Object?> get props => [
    campus,
    origin,
    originAddress,
    destination,
    destinationAddress,
    vehicleType,
    passengers,
    weightItems,
    schedule,
    loading,
    errorMessage,
    booking,
  ];
}

import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class CreateBookingUsecase implements Usecase<Booking, CreateBookingParams> {
  final BookingRepository bookingRepository;

  const CreateBookingUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(CreateBookingParams params) {
    return bookingRepository.createBooking(
      origin: params.origin,
      originAddress: params.originAddress,
      destination: params.destination,
      destinationAddress: params.destinationAddress,
      vehicleType: params.vehicleType,
      passengers: params.passengers,
      weightItems: params.weightItems,
      schedule: params.schedule,
      campusId: params.campusId,
    );
  }
}

class CreateBookingParams {
  final String campusId;
  final LatLng origin;
  final String originAddress;
  final LatLng destination;
  final String destinationAddress;
  final String vehicleType;
  final List<Passenger> passengers;
  final List<WeightItem> weightItems;
  final DateTime schedule;

  CreateBookingParams({
    required this.campusId,
    required this.origin,
    required this.originAddress,
    required this.destination,
    required this.destinationAddress,
    required this.vehicleType,
    required this.passengers,
    required this.weightItems,
    required this.schedule,
  });
}

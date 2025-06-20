import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/booking/booking.dart';

abstract interface class BookingRepository {
  Future<Either<Failure, Booking>> createBooking({
    required LatLng origin,
    required String campusId,
    required String originAddress,
    required LatLng destination,
    required String destinationAddress,
    required String vehicleType,
    required List<Passenger> passengers,
    required List<WeightItem> weightItems,
    required DateTime schedule,
  });

  Future<Either<Failure, Booking>> getBookingById({required String bookingId});

  Future<Either<Failure, Booking>> assignVehicleUsingBookingId({
    required String bookingId,
  });

  Future<Either<Failure, Booking>> verifyBookingOtp({
    required String bookingId,
    required String otp,
  });

  Future<Either<Failure, Booking>> cancelBooking({required String bookingId});

  Future<Either<Failure, Booking>> emergencyStopBooking({
    required String bookingId,
    required String reason,
  });

  Future<Either<Failure, Booking>> completeBooking({required String bookingId});

  Future<Either<Failure, List<Booking>>> getPastBookings();
  Future<Either<Failure, List<Booking>>> getUpcomingBookings();
}

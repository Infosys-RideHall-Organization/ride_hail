import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_hail/core/constants/constants.dart';
import 'package:ride_hail/core/error/failure.dart';
import 'package:ride_hail/core/services/secure_storage/secure_storage_service.dart';
import 'package:ride_hail/features/booking/domain/entities/booking/booking.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../domain/repositories/booking/booking_repository.dart';
import '../../datasources/booking/booking_remote_data_source.dart';
import '../../models/booking/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource bookingRemoteDataSource;
  final SecureStorageService secureStorageService;

  BookingRepositoryImpl({
    required this.secureStorageService,
    required this.bookingRemoteDataSource,
  });

  @override
  Future<Either<Failure, Booking>> createBooking({
    required String campusId,
    required LatLng origin,
    required String originAddress,
    required LatLng destination,
    required String destinationAddress,
    required String vehicleType,
    required List<Passenger> passengers,
    required List<WeightItem> weightItems,
    required DateTime schedule,
  }) async {
    try {
      final userId = await secureStorageService.getString(Constants.userIdKey);
      final geocode = await bookingRemoteDataSource.createBooking(
        userId: userId!,
        campusId: campusId,
        origin: origin,
        originAddress: originAddress,
        destination: destination,
        destinationAddress: destinationAddress,
        vehicleType: vehicleType,
        passengers:
            passengers
                .map(
                  (e) => PassengerModel(
                    name: e.name,
                    phoneNo: e.phoneNo,
                    email: e.email,
                    companyName: e.companyName,
                  ),
                )
                .toList(),
        weightItems:
            weightItems
                .map((e) => WeightItemModel(name: e.name, weight: e.weight))
                .toList(),
        schedule: schedule,
      );
      return right(geocode);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Booking>> getBookingById({
    required String bookingId,
  }) async {
    try {
      final booking = await bookingRemoteDataSource.getBookingById(
        bookingId: bookingId,
      );
      return right(booking);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Booking>> assignVehicleUsingBookingId({
    required String bookingId,
  }) async {
    try {
      final booking = await bookingRemoteDataSource.assignVehicleUsingBookingId(
        bookingId: bookingId,
      );
      return right(booking);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Booking>> verifyBookingOtp({
    required String bookingId,
    required String otp,
  }) async {
    try {
      final booking = await bookingRemoteDataSource.verifyBookingOtp(
        bookingId: bookingId,
        otp: otp,
      );
      return right(booking);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Booking>> cancelBooking({
    required String bookingId,
  }) async {
    try {
      final booking = await bookingRemoteDataSource.cancelBooking(
        bookingId: bookingId,
      );
      return right(booking);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Booking>> emergencyStopBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final booking = await bookingRemoteDataSource.emergencyStopBooking(
        bookingId: bookingId,
        reason: reason,
      );
      return right(booking);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Booking>> completeBooking({
    required String bookingId,
  }) async {
    try {
      final booking = await bookingRemoteDataSource.completeBooking(
        bookingId: bookingId,
      );
      return right(booking);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getPastBookings() async {
    final userId = await secureStorageService.getString(Constants.userIdKey);
    try {
      final bookings = await bookingRemoteDataSource.getPastBookings(
        userId: userId!,
      );
      return right(bookings);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUpcomingBookings() async {
    try {
      final userId = await secureStorageService.getString(Constants.userIdKey);
      final bookings = await bookingRemoteDataSource.getUpcomingBookings(
        userId: userId!,
      );
      return right(bookings);
    } on ServerException catch (e) {
      debugPrint('Booking Error: ${e.message}');
      return left(Failure(e.message));
    }
  }
}

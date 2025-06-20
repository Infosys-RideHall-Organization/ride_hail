import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class EmergencyStopUsecase implements Usecase<Booking, EmergencyStopParams> {
  final BookingRepository bookingRepository;

  const EmergencyStopUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(EmergencyStopParams params) {
    return bookingRepository.emergencyStopBooking(
      bookingId: params.bookingId,
      reason: params.reason,
    );
  }
}

class EmergencyStopParams {
  final String bookingId;
  final String reason;

  EmergencyStopParams({required this.bookingId, required this.reason});
}

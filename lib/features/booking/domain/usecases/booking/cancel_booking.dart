import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class CancelBookingUsecase implements Usecase<Booking, CancelBookingParams> {
  final BookingRepository bookingRepository;

  const CancelBookingUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(CancelBookingParams params) {
    return bookingRepository.cancelBooking(bookingId: params.bookingId);
  }
}

class CancelBookingParams {
  final String bookingId;

  CancelBookingParams({required this.bookingId});
}

import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class CompleteBookingUsecase
    implements Usecase<Booking, CompleteBookingParams> {
  final BookingRepository bookingRepository;

  const CompleteBookingUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(CompleteBookingParams params) {
    return bookingRepository.completeBooking(bookingId: params.bookingId);
  }
}

class CompleteBookingParams {
  final String bookingId;

  CompleteBookingParams({required this.bookingId});
}

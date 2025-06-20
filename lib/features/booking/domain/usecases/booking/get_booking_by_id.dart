import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class GetBookingByIdUsecase implements Usecase<Booking, GetBookingByIdParams> {
  final BookingRepository bookingRepository;

  const GetBookingByIdUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(GetBookingByIdParams params) {
    return bookingRepository.getBookingById(bookingId: params.bookingId);
  }
}

class GetBookingByIdParams {
  final String bookingId;

  GetBookingByIdParams({required this.bookingId});
}

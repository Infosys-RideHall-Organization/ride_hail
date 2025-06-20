import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class GetPastBookingsUsecase implements Usecase<List<Booking>, NoParams> {
  final BookingRepository bookingRepository;

  const GetPastBookingsUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, List<Booking>>> call(NoParams params) {
    return bookingRepository.getPastBookings();
  }
}

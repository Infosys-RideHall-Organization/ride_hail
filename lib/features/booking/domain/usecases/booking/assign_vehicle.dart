import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class AssignVehicleUsecase implements Usecase<Booking, AssignVehicleParams> {
  final BookingRepository bookingRepository;

  const AssignVehicleUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(AssignVehicleParams params) {
    return bookingRepository.assignVehicleUsingBookingId(
      bookingId: params.bookingId,
    );
  }
}

class AssignVehicleParams {
  final String bookingId;

  AssignVehicleParams({required this.bookingId});
}

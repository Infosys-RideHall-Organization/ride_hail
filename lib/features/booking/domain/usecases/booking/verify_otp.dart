import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/booking/booking.dart';
import '../../repositories/booking/booking_repository.dart';

class VerifyOtpUsecase implements Usecase<Booking, VerifyOtpParams> {
  final BookingRepository bookingRepository;

  const VerifyOtpUsecase({required this.bookingRepository});

  @override
  Future<Either<Failure, Booking>> call(VerifyOtpParams params) {
    return bookingRepository.verifyBookingOtp(
      bookingId: params.bookingId,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String bookingId;
  final String otp;

  VerifyOtpParams({required this.bookingId, required this.otp});
}

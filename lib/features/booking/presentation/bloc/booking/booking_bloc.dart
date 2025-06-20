import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/assign_vehicle.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/complete_booking.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/create_booking.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/get_booking_by_id.dart';

import '../../../domain/entities/booking/booking.dart';
import '../../../domain/entities/campus/campus.dart';
import '../../../domain/usecases/booking/cancel_booking.dart';
import '../../../domain/usecases/booking/emergency_stop.dart';
import '../../../domain/usecases/booking/verify_otp.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUsecase _createBookingUsecase;
  final GetBookingByIdUsecase _getBookingByIdUsecase;
  final AssignVehicleUsecase _assignVehicleUsecase;
  final CancelBookingUsecase _cancelBookingUsecase;
  final EmergencyStopUsecase _emergencyStopUsecase;
  final CompleteBookingUsecase _completeBookingUsecase;

  final VerifyOtpUsecase _verifyOtpUsecase;
  BookingBloc({
    required CreateBookingUsecase createBookingUsecase,
    required GetBookingByIdUsecase getBookingByIdUsecase,
    required AssignVehicleUsecase assignVehicleUsecase,
    required VerifyOtpUsecase verifyOtpUsecase,
    required CancelBookingUsecase cancelBookingUsecase,
    required EmergencyStopUsecase emergencyStopUsecase,
    required CompleteBookingUsecase completeBookingUsecase,
  }) : _createBookingUsecase = createBookingUsecase,
       _getBookingByIdUsecase = getBookingByIdUsecase,
       _assignVehicleUsecase = assignVehicleUsecase,
       _verifyOtpUsecase = verifyOtpUsecase,
       _emergencyStopUsecase = emergencyStopUsecase,
       _completeBookingUsecase = completeBookingUsecase,
       _cancelBookingUsecase = cancelBookingUsecase,
       super(BookingState()) {
    on<UpdateOriginAndAddress>((event, emit) {
      emit(
        state.copyWith(
          origin: event.origin,
          originAddress: event.originAddress,
        ),
      );
    });

    on<UpdateDestinationAndAddress>((event, emit) {
      emit(
        state.copyWith(
          destination: event.destination,
          destinationAddress: event.destinationAddress,
        ),
      );
    });

    on<UpdateVehicleType>((event, emit) {
      emit(state.copyWith(vehicleType: event.vehicleType));
    });

    on<UpdateCampusSelected>((event, emit) {
      emit(state.copyWith(campus: event.campus));
    });

    on<UpdatePassengers>((event, emit) {
      emit(state.copyWith(passengers: event.passengers));
    });

    on<UpdateWeights>((event, emit) {
      emit(state.copyWith(weightItems: event.weightItems));
    });

    on<UpdateSchedule>((event, emit) {
      emit(state.copyWith(schedule: event.schedule));
    });

    on<SubmitBooking>((event, emit) async {
      emit(state.copyWith(loading: true));

      final result = await _createBookingUsecase(
        CreateBookingParams(
          campusId: state.campus!.id,
          origin: state.origin!,
          originAddress: state.originAddress!,
          destination: state.destination!,
          destinationAddress: state.destinationAddress!,
          vehicleType: state.vehicleType!,
          passengers: state.passengers,
          weightItems: state.weightItems,
          schedule: state.schedule!,
        ),
      );

      await result.fold(
        (failure) async {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (booking) async {
          emit(
            state.copyWith(
              loading: false,
              errorMessage: null,
              booking: booking,
            ),
          );

          //  Step 2: Call assignVehicle
          final assignResult = await _assignVehicleUsecase(
            AssignVehicleParams(bookingId: booking.id),
          );

          assignResult.fold(
            (failure) {
              emit(state.copyWith(errorMessage: failure.message));
            },
            (_) {
              //  Step 3: Start polling
              add(PollBookingStatus(booking.id));
            },
          );
        },
      );
    });

    on<GetBookingByIdEvent>((event, emit) async {
      emit(state.copyWith(loading: true, errorMessage: null));

      final result = await _getBookingByIdUsecase(
        GetBookingByIdParams(bookingId: event.bookingId),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (booking) {
          emit(state.copyWith(loading: false, booking: booking));
        },
      );
    });

    on<PollBookingStatus>((event, emit) async {
      const interval = Duration(seconds: 5);
      const timeout = Duration(minutes: 1);
      final startTime = DateTime.now();

      bool shouldExitLoop = false;

      while (DateTime.now().difference(startTime) < timeout &&
          !shouldExitLoop) {
        await Future.delayed(interval);

        final result = await _getBookingByIdUsecase(
          GetBookingByIdParams(bookingId: event.bookingId),
        );

        result.fold(
          (failure) => emit(state.copyWith(errorMessage: failure.message)),
          (booking) {
            if (booking.vehicleId != null) {
              emit(state.copyWith(booking: booking));
              shouldExitLoop = true;
            }
          },
        );
      }
    });

    on<VerifyOtp>((event, emit) async {
      emit(state.copyWith(loading: true));

      final result = await _verifyOtpUsecase(
        VerifyOtpParams(bookingId: state.booking!.id, otp: event.otp),
      );

      await result.fold(
        (failure) async {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (booking) async {
          emit(
            state.copyWith(
              loading: false,
              errorMessage: null,
              booking: booking,
            ),
          );
        },
      );
    });

    on<CancelBooking>((event, emit) async {
      emit(state.copyWith(loading: true));

      final result = await _cancelBookingUsecase(
        CancelBookingParams(bookingId: state.booking!.id),
      );

      await result.fold(
        (failure) async {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (_) async {
          // Directly emit the reset state instead of dispatching another event
          emit(state.clearSessionData());
        },
      );
    });

    on<EmergencyStop>((event, emit) async {
      emit(state.copyWith(loading: true));

      final result = await _emergencyStopUsecase(
        EmergencyStopParams(bookingId: state.booking!.id, reason: event.reason),
      );

      await result.fold(
        (failure) async {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (_) async {
          // Directly emit the reset state instead of dispatching another event
          emit(state.clearSessionData());
        },
      );
    });

    on<CompleteBooking>((event, emit) async {
      emit(state.copyWith(loading: true));

      final result = await _completeBookingUsecase(
        CompleteBookingParams(bookingId: state.booking!.id),
      );

      await result.fold(
        (failure) async {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (_) async {
          // Directly emit the reset state instead of dispatching another event
          emit(state.clearSessionData());
        },
      );
    });

    on<ResetBooking>((event, emit) {
      emit(state.clearSessionData());
    });
  }
}

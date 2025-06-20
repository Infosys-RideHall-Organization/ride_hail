import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../booking/presentation/bloc/booking/booking_bloc.dart';
import '../../../../booking/presentation/widgets/home/outlined_button.dart';

class RideStatusWidget extends StatefulWidget {
  const RideStatusWidget({
    super.key,
    required this.onVerifyOTP,
    required this.finishRide,
  });
  final VoidCallback onVerifyOTP;
  final VoidCallback finishRide;
  @override
  State<RideStatusWidget> createState() => _RideStatusWidgetState();
}

class _RideStatusWidgetState extends State<RideStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ride time and verification and otp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (state.booking?.otpVerified ?? false)
                        ? Row(
                          children: [
                            const SizedBox(width: 8.0),
                            const Text(
                              'The ride is Verified',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(width: 8.0),
                            Icon(
                              Icons.verified,
                              color: AppPalette.secondaryColor,
                              size: 18,
                            ),
                          ],
                        )
                        : const Text(
                          'On the way to pick up passenger',
                          style: TextStyle(fontSize: 18.0),
                        ),
                  ],
                ),
                const SizedBox(height: 16),
                // booking id and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID #${state.booking?.id.substring(3, 7) ?? ''}',
                          style: const TextStyle(fontSize: 24.0),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Date & Time',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppPalette.greyColor,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy - HH:mm a',
                          ).format(state.schedule ?? DateTime.now()),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          'assets/images/buggy-ride-2x.png',
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1.0,
                              horizontal: 24.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppPalette.primaryColor,
                            ),
                            child: Text(state.booking?.vehicleType ?? ''),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomOutlinedButton(
                  onPressed:
                      (state.booking?.otpVerified ?? false)
                          ? widget.finishRide
                          : widget.onVerifyOTP,

                  buttonName:
                      state.booking?.otpVerified ?? false
                          ? 'Finish Ride'
                          : 'Verify OTP',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

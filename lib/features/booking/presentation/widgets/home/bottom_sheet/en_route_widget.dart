import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ride_hail/core/common/widgets/toast.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:ride_hail/features/booking/presentation/bloc/stage/booking_stage_cubit.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/outlined_button.dart';
import 'package:toastification/toastification.dart';

import '../../../bloc/booking/booking_bloc.dart';

class EnRouteWidget extends StatefulWidget {
  const EnRouteWidget({
    super.key,
    required this.onCancelled,
    required this.onEmergencyStop,
  });

  final VoidCallback onCancelled;
  final VoidCallback onEmergencyStop;

  @override
  State<EnRouteWidget> createState() => _EnRouteWidgetState();
}

class _EnRouteWidgetState extends State<EnRouteWidget> {
  final TextEditingController reasonController = TextEditingController();

  Future<void> showReasonDialog({
    required BuildContext context,
    required Function(String reason) onSubmitted,
    String title = "Enter Reason",
    String hintText = "Type your reason here...",
  }) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  // Cache providers BEFORE pop
                  final bookingBloc = context.read<BookingBloc>();
                  final bookingStageCubit = context.read<BookingStageCubit>();
                  onSubmitted(reason);
                  bookingBloc.add(EmergencyStop(reason: reason));
                  widget.onEmergencyStop();
                  bookingStageCubit.reset();
                  reasonController.clear();
                  Navigator.of(dialogContext).pop();
                  context.pop();
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void showCancelRideDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("Cancel Ride"),
            content: const Text("Are you sure you want to cancel the ride?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Close dialog first
                  Navigator.of(dialogContext).pop();

                  try {
                    // Call the cancellation callback
                    widget.onCancelled();
                  } catch (e) {
                    // Close loading dialog
                    // Show error
                    showToast(
                      context: context,
                      type: ToastificationType.error,
                      description: 'Failed to cancel ride. Please try again.',
                    );
                  }
                },
                child: const Text("Yes, Cancel"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

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
                          spacing: 8.0,
                          children: [
                            const Text(
                              'Your ride is Verified',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Icon(
                              Icons.verified,
                              color: AppPalette.secondaryColor,
                              size: 18,
                            ),
                          ],
                        )
                        : const Text(
                          'Your ride is on the way',
                          style: TextStyle(fontSize: 18.0),
                        ),
                    Column(
                      children: [
                        const Text('OTP:', style: TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            for (
                              int i = 0;
                              i < (state.booking?.otp.length ?? 0);
                              i++
                            )
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: AppPalette.primaryColor,
                                  ),
                                  child: Text(state.booking!.otp[i]),
                                ),
                              ),
                          ],
                        ),
                      ],
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
                            child: Text(state.vehicleType ?? ''),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomOutlinedButton(
                  onPressed: () {
                    if (state.booking?.otpVerified ?? false) {
                      showReasonDialog(
                        context: context,
                        title: "Cancel Booking",
                        hintText: "Why are you cancelling?",
                        onSubmitted: (reason) {
                          debugPrint("User reason: $reason");
                        },
                      );
                    } else {
                      showCancelRideDialog(context);
                    }
                  },
                  buttonName:
                      state.booking?.otpVerified ?? false
                          ? 'Emergency Stop'
                          : 'Cancel Ride',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

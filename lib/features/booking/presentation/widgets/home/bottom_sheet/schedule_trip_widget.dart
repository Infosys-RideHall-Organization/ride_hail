import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:ride_hail/core/common/widgets/toast.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:ride_hail/core/theme/cubit/theme_cubit.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../core/common/widgets/custom_elevated_button.dart';
import '../../../bloc/booking/booking_bloc.dart';
import '../../../bloc/map/map_bloc.dart';
import '../../../bloc/stage/booking_stage_cubit.dart';
import '../outlined_button.dart';

class ScheduleTripWidget extends StatefulWidget {
  const ScheduleTripWidget({super.key});

  @override
  State<ScheduleTripWidget> createState() => _ScheduleTripWidgetState();
}

class _ScheduleTripWidgetState extends State<ScheduleTripWidget> {
  DateTime? _selectedDate;
  bool _isScheduled = false;

  void _showDateTimePicker({bool shouldSchedule = false}) {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      theme:
          context.read<ThemeCubit>().state.appTheme == AppThemeMode.dark
              ? picker.DatePickerTheme(
                backgroundColor: AppPalette.darkBackgroundColor,
                itemStyle: TextStyle(color: AppPalette.primaryColor),
                cancelStyle: TextStyle(color: AppPalette.primaryColor),
                doneStyle: TextStyle(color: AppPalette.primaryColor),
                //headerColor: AppPalette.primaryColor,
              )
              : picker.DatePickerTheme(
                backgroundColor: AppPalette.whiteColor,
                itemStyle: TextStyle(color: AppPalette.primaryColor),
                cancelStyle: TextStyle(color: AppPalette.primaryColor),
                doneStyle: TextStyle(color: AppPalette.primaryColor),
                // headerColor: AppPalette.primaryColor,
              ),
      minTime: DateTime.now(),
      onConfirm: (date) {
        setState(() {
          _selectedDate = date;
        });

        context.read<BookingBloc>().add(UpdateSchedule(date));

        if (shouldSchedule) {
          // For scheduled bookings, just update the schedule and show success
          // Don't submit the booking (which triggers vehicle assignment)
          setState(() {
            _isScheduled = true;
          });

          context.read<BookingBloc>().add(SubmitBooking());

          // Reset to initial state or navigate back
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              // You can either reset the booking flow or navigate to a different screen
              context.read<BookingBloc>().add(ResetBooking());
              context.read<MapBloc>().add(ResetMap());
              context.read<BookingStageCubit>().reset();
              showToast(
                context: context,
                type: ToastificationType.success,
                description: "Booking Schedule Successfully!",
              );
              // Or navigate to a scheduled bookings list screen
              // Navigator.pop(context);
            }
          });
        }
      },
      currentTime: DateTime.now(),
      locale: picker.LocaleType.en,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        // Only handle immediate bookings (Book Now button)
        if (state.booking != null && !_isScheduled) {
          debugPrint('Immediate booking confirmed. Moving to next stage.');
          context.read<BookingStageCubit>().nextStage();
        }

      },
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule Date and Time',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 24.0),

                // Display selected date if any
                // if (_selectedDate != null)
                //   Container(
                //     padding: const EdgeInsets.all(16.0),
                //     decoration: BoxDecoration(
                //       color: AppPalette.primaryColor.withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(8.0),
                //       border: Border.all(
                //         color: AppPalette.primaryColor.withOpacity(0.3),
                //       ),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.schedule,
                //           color: AppPalette.primaryColor,
                //           size: 20,
                //         ),
                //         const SizedBox(width: 12.0),
                //         Expanded(
                //           child: Text(
                //             "Selected: ${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')} ${_selectedDate!.hour.toString().padLeft(2, '0')}:${_selectedDate!.minute.toString().padLeft(2, '0')}",
                //             style: TextStyle(
                //               fontSize: 16.0,
                //               color: AppPalette.primaryColor,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //
                // if (_selectedDate != null) const SizedBox(height: 24.0),

                Center(
                  child: CustomElevatedButton(
                    buttonName: 'Book Now',
                    onPressed: () {
                      context.read<BookingBloc>().add(
                        UpdateSchedule(DateTime.now()),
                      );
                      context.read<BookingBloc>().add(SubmitBooking());
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                Center(
                  child: CustomOutlinedButton(
                    onPressed: () {
                      _showDateTimePicker(shouldSchedule: true);
                    },
                    buttonName: 'Schedule Booking',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

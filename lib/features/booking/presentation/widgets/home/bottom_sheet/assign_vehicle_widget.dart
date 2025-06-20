import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:ride_hail/features/booking/presentation/bloc/stage/booking_stage_cubit.dart';

import '../../../bloc/booking/booking_bloc.dart';

class AssignVehicleWidget extends StatefulWidget {
  const AssignVehicleWidget({super.key});

  @override
  State<AssignVehicleWidget> createState() => _AssignVehicleWidgetState();
}

class _AssignVehicleWidgetState extends State<AssignVehicleWidget> {
  @override
  void initState() {
    super.initState();
    final vehicleId = context.read<BookingBloc>().state.booking?.vehicleId;
    if (vehicleId != null) {
      context.read<BookingStageCubit>().nextStage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listenWhen:
          (previous, current) =>
              previous.booking?.vehicleId != current.booking?.vehicleId,
      listener: (context, state) {
        if (state.booking?.vehicleId != null) {
          // Navigate to success or tracking screen
          Future.delayed(Duration(seconds: 2));
          context.read<BookingStageCubit>().nextStage();
          debugPrint('Vehicle Assigned!');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            const Text(
              "Please wait while we assign a vehicle…",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const Text(
              "This might take a few moments based on availability.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                minHeight: 16,
                color: AppPalette.primaryColor,
                backgroundColor: AppPalette.primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

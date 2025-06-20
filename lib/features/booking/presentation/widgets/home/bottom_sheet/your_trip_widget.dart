import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/booking/booking_bloc.dart';
import '../../../bloc/map/map_bloc.dart';
import '../../../bloc/stage/booking_stage_cubit.dart';
import '../outlined_button.dart';

class YourTripWidget extends StatelessWidget {
  const YourTripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Confirm pickup header
              const Text('Your Trip', style: TextStyle(fontSize: 24.0)),
              const SizedBox(height: 24.0),

              // Display pickup location
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your location',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.originFormattedAddress,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // Display destination
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Drop Location',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.destinationFormattedAddress,
                          style: const TextStyle(fontSize: 14.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              // Confirmation button
              Center(
                child: CustomOutlinedButton(
                  onPressed: () {
                    // Move to select route stage
                    context.read<BookingBloc>().add(
                      UpdateOriginAndAddress(
                        state.origin!,
                        state.originFormattedAddress,
                      ),
                    );
                    context.read<BookingBloc>().add(
                      UpdateDestinationAndAddress(
                        state.destination!,
                        state.destinationFormattedAddress,
                      ),
                    );
                    context.read<BookingStageCubit>().nextStage();
                  },
                  buttonName: 'Next',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_hail/core/theme/app_palette.dart';

import '../../../bloc/map/map_bloc.dart';
import '../../../bloc/stage/booking_stage_cubit.dart';
import '../outlined_button.dart';

class ConfirmPickupWidget extends StatelessWidget {
  const ConfirmPickupWidget({super.key});

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
              const Text('Confirm Pickup', style: TextStyle(fontSize: 24.0)),
              const SizedBox(height: 24.0),

              // Display pickup location
              Row(
                children: [
                  Icon(Icons.location_on, color: AppPalette.primaryColor),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup',
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
              // Row(
              //   children: [
              //     const Icon(Icons.location_on, color: Colors.red),
              //     const SizedBox(width: 16.0),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             'Destination',
              //             style: TextStyle(
              //               fontSize: 16.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             state.destinationFormattedAddress,
              //             style: const TextStyle(fontSize: 14.0),
              //             maxLines: 2,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24.0),
              // Confirmation button
              Center(
                child: BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    return CustomOutlinedButton(
                      onPressed: () {
                        // Move to select route stage
                        final Set<Polyline> newPolyLineSet = {};
                        newPolyLineSet.add(
                          Polyline(
                            polylineId: const PolylineId('route'),
                            color: AppPalette.secondaryColor,
                            points: state.polylineCoordinates,
                            width: 6,
                          ),
                        );

                        context.read<MapBloc>().add(
                          UpdatePolylines(
                            polylines: newPolyLineSet,
                            polylineCoordinates: state.polylineCoordinates,
                          ),
                        );
                        context.read<MapBloc>().add(
                          FetchDirections(
                            origin: state.origin!,
                            destination: state.destination!,
                          ),
                        );

                        context.read<BookingStageCubit>().nextStage();
                      },
                      buttonName: 'Confirm Pickup',
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

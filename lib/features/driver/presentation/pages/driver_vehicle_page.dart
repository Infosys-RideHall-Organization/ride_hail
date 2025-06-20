import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:ride_hail/features/booking/domain/enums/vehicle_type.dart';
import 'package:ride_hail/features/driver/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:string_validator/string_validator.dart';

class DriverVehiclePage extends StatefulWidget {
  const DriverVehiclePage({super.key});

  @override
  State<DriverVehiclePage> createState() => _DriverVehiclePageState();
}

class _DriverVehiclePageState extends State<DriverVehiclePage> {
  @override
  void initState() {
    super.initState();
    {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<VehicleBloc>().add(GetVehicleByDriverId());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is VehicleLoading) {
            return Center(child: CustomLoadingIndicator());
          }
          if (state is VehicleLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    // Vehicle Image
                    if (state.vehicle.type.equals(
                      VehicleType.buggy.displayValue,
                    ))
                      Center(
                        child: Image.asset(
                          'assets/images/buggy-ride-2x.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (state.vehicle.type.equals(
                      VehicleType.transportTruck.displayValue,
                    ))
                      Center(
                        child: Image.asset(
                          'assets/images/transport-truck-2x.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (state.vehicle.type.equals(VehicleType.bot.displayValue))
                      Center(
                        child: Image.asset(
                          'assets/images/bot.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                    Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 2),
                    Text(
                      'Assigned Vehicle',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(state.vehicle.type, style: TextStyle(fontSize: 18.0)),
                    Divider(height: 2),
                    Text(
                      'Identification Number',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      state.vehicle.identifier,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Divider(height: 2),
                    Text(
                      'Booking Status',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      state.vehicle.isBooked ? 'Booked' : 'Not Booked',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Divider(height: 3),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 4.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/buggy-ride-2x.png',
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'You don’t have a vehicle assigned right now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: AppPalette.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.read<VehicleBloc>().add(GetVehicleByDriverId()),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

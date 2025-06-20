import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ride_hail/core/common/widgets/custom_elevated_button.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/routes/app_routes.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../booking/domain/enums/vehicle_type.dart';
import '../../../booking/presentation/bloc/booking/booking_bloc.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String? _bookingId;

  @override
  void initState() {
    super.initState();
    _listenToNotificationClicks();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sendDriverTag();
    });
  }

  Future<void> sendDriverTag() async {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is! AppUserLoggedIn) {
      debugPrint("User not logged in. Skipping player ID tagging.");
      return;
    }

    final userType = appUserState.user.role;
    debugPrint("User type is = $userType");

    if (userType == 'driver') {
      debugPrint("Tagging OneSignal user as driver...");
      await OneSignal.User.addTagWithKey("user_type", "driver");
    }
  }

  void _listenToNotificationClicks() {
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;

      if (data != null && data.containsKey('bookingId')) {
        final bookingId = data['bookingId'] as String;
        debugPrint("Notification clicked. Booking ID: $bookingId");

        setState(() {
          _bookingId = bookingId;
        });

        context.read<BookingBloc>().add(GetBookingByIdEvent(bookingId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state.loading) {
              return Center(child: CustomLoadingIndicator());
            }
            if (_bookingId == null || state.booking == null) {
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
                          'You are not assigned to a booking right now.',
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
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 6.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assigned Booking Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.booking != null) ...[
                      if (state.booking!.vehicleType.equals(
                        VehicleType.buggy.displayValue,
                      ))
                        Center(
                          child: Image.asset(
                            'assets/images/buggy-ride-2x.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (state.booking!.vehicleType.equals(
                        VehicleType.transportTruck.displayValue,
                      ))
                        Center(
                          child: Image.asset(
                            'assets/images/transport-truck-2x.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (state.booking!.vehicleType.equals(
                        VehicleType.bot.displayValue,
                      ))
                        Center(
                          child: Image.asset(
                            'assets/images/bot.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      Divider(thickness: 2),
                      Text(
                        'Campus',
                        style: TextStyle(
                          color: AppPalette.secondaryColor,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        state.booking!.campus.name,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Divider(thickness: 2),
                      Text(
                        'Pickup Address',
                        style: TextStyle(
                          color: AppPalette.secondaryColor,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        state.booking!.originAddress,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Divider(thickness: 2),

                      Text(
                        'Destination Address',
                        style: TextStyle(
                          color: AppPalette.secondaryColor,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        state.booking!.destinationAddress,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Divider(thickness: 2),
                      Text(
                        'Scheduled Date and Time',
                        style: TextStyle(
                          color: AppPalette.secondaryColor,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'dd-MM-yyyy – kk:mm a',
                        ).format(state.booking!.schedule).toString(),
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Divider(thickness: 2),
                      CustomElevatedButton(
                        onPressed: () {
                          context.push(
                            '${AppRoutes.driverHome}${AppRoutes.driverMap}',
                          );
                        },
                        buttonName: 'Drive',
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

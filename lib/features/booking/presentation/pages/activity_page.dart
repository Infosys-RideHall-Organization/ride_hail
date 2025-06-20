import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/booking/booking.dart';
import '../bloc/activity/activity_bloc.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    super.initState();
    {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<ActivityBloc>().add(GetPastBookings());
        context.read<ActivityBloc>().add(GetUpcomingBookings());
      });
    }
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _showBookingDetailsBottomSheet(BuildContext context, Booking booking) {
    final current = booking;
    final schedule = current.schedule;
    final day = schedule.day;
    final suffix = getDaySuffix(day);
    final formattedDate =
        '${DateFormat('EEEE').format(schedule)} $day$suffix ${DateFormat('MMMM').format(schedule)}';
    final formattedTime = DateFormat('h:mm a').format(schedule).toLowerCase();
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image
                    if (booking.vehicleType == 'Buggy')
                      Image.asset(
                        'assets/images/buggy-ride-2x.png',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      )
                    else if (booking.vehicleType == 'Transport Truck')
                      Image.asset(
                        'assets/images/transport-truck-2x.png',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      )
                    else
                      Image.asset(
                        'assets/images/bot.png',
                        fit: BoxFit.cover,
                        height: 125,
                        width: 125,
                      ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking ID #${booking.id.substring(3, 7)}',
                            style: const TextStyle(fontSize: 24.0),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: AppPalette.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              color: AppPalette.greyColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campus',
                      style: TextStyle(
                        color: AppPalette.secondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(booking.campus.name),
                  ],
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pick up',
                      style: TextStyle(
                        color: AppPalette.secondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(booking.originAddress),
                  ],
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drop Off',
                      style: TextStyle(
                        color: AppPalette.secondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(booking.destinationAddress),
                  ],
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        color: AppPalette.secondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(booking.status.toUpperCase()),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon((Icons.refresh)),
        onPressed: () {
          context.read<ActivityBloc>().add(GetPastBookings());
          context.read<ActivityBloc>().add(GetUpcomingBookings());
        },
      ),
      body: SafeArea(
        child: BlocConsumer<ActivityBloc, ActivityState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ActivityLoading) {
              return Center(child: CustomLoadingIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  spacing: 16.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Upcoming
                    Text(
                      'Upcoming Bookings',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    state.upcomingBookings.isEmpty
                        ? Center(child: Text('No upcoming bookings'))
                        : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.upcomingBookings.length,
                          itemBuilder: (context, index) {
                            final current = state.upcomingBookings[index];
                            final schedule = current.schedule;
                            final day = schedule.day;
                            final suffix = getDaySuffix(day);
                            final formattedDate =
                                '${DateFormat('EEEE').format(schedule)} $day$suffix ${DateFormat('MMMM').format(schedule)}';
                            final formattedTime =
                                DateFormat(
                                  'h:mm a',
                                ).format(schedule).toLowerCase();

                            return Container(
                              padding: EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppPalette.greyColor),
                              ),
                              child: Row(
                                spacing: 8.0,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Details
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Booking ID
                                      Text(
                                        'Booking ID #${current.id.substring(3, 7)}',
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      // Formatted Date and Time
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: AppPalette.secondaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: AppPalette.greyColor,
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      GestureDetector(
                                        onTap:
                                            () =>
                                                _showBookingDetailsBottomSheet(
                                                  context,
                                                  current,
                                                ),
                                        child: Text(
                                          'View Details',
                                          style: TextStyle(
                                            decorationThickness: 1,
                                            color: AppPalette.secondaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            decorationColor:
                                                AppPalette.secondaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Image
                                  if (current.vehicleType == 'Buggy')
                                    Image.asset(
                                      'assets/images/buggy-ride-2x.png',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    )
                                  else if (current.vehicleType ==
                                      'Transport Truck')
                                    Image.asset(
                                      'assets/images/transport-truck-2x.png',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    )
                                  else
                                    Image.asset(
                                      'assets/images/bot.png',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                    Divider(),
                    // Past
                    Text(
                      'Past Bookings',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.pastBookings.length,
                      itemBuilder: (context, index) {
                        final current = state.pastBookings[index];
                        final schedule = current.schedule;
                        final day = schedule.day;
                        final suffix = getDaySuffix(day);
                        final formattedDate =
                            '${DateFormat('EEEE').format(schedule)} $day$suffix ${DateFormat('MMMM').format(schedule)}';
                        final formattedTime =
                            DateFormat('h:mm a').format(schedule).toLowerCase();

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 16.0,
                          children: [
                            // Image
                            if (current.vehicleType == 'Buggy')
                              Image.asset(
                                'assets/images/buggy-ride-2x.png',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              )
                            else if (current.vehicleType == 'Transport Truck')
                              Image.asset(
                                'assets/images/transport-truck-2x.png',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              )
                            else
                              Image.asset(
                                'assets/images/bot.png',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            // Details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Booking ID
                                Text(
                                  'Booking ID #${current.id.substring(3, 7)}',
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                // Formatted Date and Time
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: AppPalette.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(color: AppPalette.greyColor),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed:
                                  () => _showBookingDetailsBottomSheet(
                                    context,
                                    current,
                                  ),
                              icon: Icon(Icons.navigate_next),
                            ),
                          ],
                        );
                      },
                    ),
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

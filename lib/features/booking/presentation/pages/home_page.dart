import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/common/widgets/toast.dart';
import 'package:ride_hail/features/booking/domain/enums/vehicle_type.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/booking/booking.dart';
import '../../domain/entities/campus/campus.dart';
import '../bloc/activity/activity_bloc.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/campus/campus_bloc.dart';
import '../widgets/services/pick_service_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pickUpServices = [
    {
      'title': 'Buggy Ride',
      'image': 'assets/images/buggy-ride.png',
      'type': VehicleType.buggy.displayValue,
    },
    {
      'title': 'Tow Truck',
      'image': 'assets/images/transport-truck.png',
      'type': VehicleType.transportTruck.displayValue,
    },
    {
      'title': 'Bot Delivery',
      'image': 'assets/images/bot.png',
      'type': VehicleType.bot.displayValue,
    },
  ];

  List<Campus> campuses = [];
  Campus? selectedCampus;

  @override
  void initState() {
    super.initState();
    context.read<CampusBloc>().add(LoadCampuses());
    context.read<ActivityBloc>().add(GetUpcomingBookings());
  }

  // Filter out cancelled bookings
  List<Booking> _filterActiveBokings(List<Booking> bookings) {
    return bookings.where((booking) =>
    booking.status.toLowerCase() != 'cancelled'
    ).toList();
  }

  void _showUpcomingBookingsBottomSheet(List<Booking> upcomingBookings) {
    // Filter out cancelled bookings before showing
    final activeBookings = _filterActiveBokings(upcomingBookings);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder:
            (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppPalette.blackColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppPalette.greyColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Bookings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: AppPalette.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                activeBookings.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 60,
                        color: AppPalette.greyColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No upcoming bookings',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppPalette.greyColor,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: activeBookings.length,
                  itemBuilder: (context, index) {
                    final booking = activeBookings[index];
                    return _buildBookingCard(booking);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.darkGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.greyColor.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getVehicleTypeColor(booking.vehicleType),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.vehicleType.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Text(
                _formatBookingStatus(booking.status),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStatusColor(booking.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppPalette.primaryColor,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${booking.originAddress} → ${booking.destinationAddress}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: AppPalette.greyColor,
              ),
              SizedBox(width: 6),
              Text(
                _formatBookingDateTime(booking.schedule),
                style: TextStyle(fontSize: 13, color: AppPalette.greyColor),
              ),
            ],
          ),
          if (booking.passengers.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: AppPalette.greyColor,
                ),
                SizedBox(width: 6),
                Text(
                  'Passengers: ${booking.passengers.length}',
                  style: TextStyle(fontSize: 13, color: AppPalette.greyColor),
                ),
              ],
            ),
          ],
          if (booking.weightItems.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                  color: AppPalette.greyColor,
                ),
                SizedBox(width: 6),
                Text(
                  'Items: ${booking.weightItems.length} (${booking.weightItems.fold(0.0, (sum, item) => sum + item.weight).toStringAsFixed(1)} kg)',
                  style: TextStyle(fontSize: 13, color: AppPalette.greyColor),
                ),
              ],
            ),
          ],
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_city_outlined,
                size: 16,
                color: AppPalette.greyColor,
              ),
              SizedBox(width: 6),
              Text(
                'Campus: ${booking.campus.name}',
                style: TextStyle(fontSize: 13, color: AppPalette.greyColor),
              ),
            ],
          ),
          if (!booking.otpVerified) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppPalette.primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppPalette.primaryColor.withAlpha(100),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.security_outlined,
                    size: 16,
                    color: AppPalette.primaryColor,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'OTP: ${booking.otp}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppPalette.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getVehicleTypeColor(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'buggy':
        return Colors.blue;
      case 'transport_truck':
        return Colors.orange;
      case 'bot':
        return Colors.green;
      default:
        return AppPalette.primaryColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppPalette.greenOpacityColor;
      case 'pending':
        return AppPalette.orangeColor;
      case 'cancelled':
        return AppPalette.redColor;
      case 'completed':
        return AppPalette.blueOpacityColor;
      default:
        return AppPalette.greyColor;
    }
  }

  String _formatBookingStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  String _formatBookingDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${_getDayName(dateTime.weekday)} ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour =
    dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<CampusBloc, CampusState>(
              listener: (context, state) {
                if (state is CampusLoaded) {
                  setState(() {
                    campuses = List.from(state.campuses);
                  });
                }
              },
            ),
            BlocListener<ActivityBloc, ActivityState>(
              listener: (context, state) {
                if (state is ActivityLoaded) {
                  // Filter out cancelled bookings before checking if we should show the bottom sheet
                  final activeBookings = _filterActiveBokings(state.upcomingBookings);
                  if (activeBookings.isNotEmpty) {
                    // Automatically show bottom sheet when upcoming bookings are loaded
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showUpcomingBookingsBottomSheet(state.upcomingBookings);
                    });
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<CampusBloc, CampusState>(
            builder: (context, campusState) {
              if (campusState is CampusLoading) {
                return Center(child: CustomLoadingIndicator());
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  spacing: 16.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icon-location-2x.png',
                          fit: BoxFit.cover,
                          height: MediaQuery.sizeOf(context).height * 0.035,
                          width: MediaQuery.sizeOf(context).height * 0.035,
                        ),
                        Flexible(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Campus>(
                              isExpanded: true,
                              hint: Text(
                                'Select Location',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppPalette.secondaryColor,
                                ),
                              ),
                              items:
                              campuses
                                  .map(
                                    (campus) => DropdownMenuItem<Campus>(
                                  value: campus,
                                  child: Text(
                                    campus.name,
                                    style: TextStyle(
                                      color: AppPalette.secondaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                                  .toList(),
                              value: selectedCampus,
                              onChanged: (campus) {
                                setState(() {
                                  selectedCampus = campus;
                                });
                                context.read<BookingBloc>().add(
                                  UpdateCampusSelected(selectedCampus!),
                                );
                              },
                              buttonStyleData: ButtonStyleData(
                                height: MediaQuery.sizeOf(context).width * 0.12,
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                padding: const EdgeInsets.only(
                                  left: 14,
                                  right: 14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppPalette.darkGreyColor,
                                ),
                                elevation: 2,
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                iconEnabledColor: AppPalette.secondaryColor,
                                iconDisabledColor: AppPalette.greyColor,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight:
                                MediaQuery.sizeOf(context).height * 0.2,
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                decoration: BoxDecoration(
                                  color: AppPalette.darkGreyColor,
                                ),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all(6),
                                  thumbVisibility: WidgetStateProperty.all(
                                    true,
                                  ),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pick a Service',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<ActivityBloc, ActivityState>(
                          builder: (context, state) {
                            if (state is ActivityLoaded) {
                              // Filter out cancelled bookings for the badge count
                              final activeBookings = _filterActiveBokings(state.upcomingBookings);
                              if (activeBookings.isNotEmpty) {
                                return GestureDetector(
                                  onTap:
                                      () => _showUpcomingBookingsBottomSheet(
                                    state.upcomingBookings,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppPalette.primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: AppPalette.whiteColor,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${activeBookings.length}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppPalette.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Pick a Service you would like to book',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: 64.0,
                        children: [
                          for (final service in pickUpServices)
                            PickServiceCard(
                              title: service['title']!,
                              image: service['image']!,
                              onTap: () {
                                if (context.read<BookingBloc>().state.campus ==
                                    null) {
                                  showToast(
                                    context: context,
                                    type: ToastificationType.error,
                                    description: 'Please select a campus',
                                  );
                                  return;
                                }
                                // handle tap
                                context.read<BookingBloc>().add(
                                  UpdateVehicleType(service['type'].toString()),
                                );
                                context.push(
                                  '${AppRoutes.home}${AppRoutes.map}',
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoaded) {
            // Filter out cancelled bookings for the floating action button
            final activeBookings = _filterActiveBokings(state.upcomingBookings);
            if (activeBookings.isNotEmpty) {
              return FloatingActionButton.extended(
                onPressed:
                    () =>
                    _showUpcomingBookingsBottomSheet(state.upcomingBookings),
                backgroundColor: AppPalette.primaryColor,
                label: Text(
                  'View Bookings (${activeBookings.length})',
                  style: TextStyle(color: AppPalette.whiteColor),
                ),
                icon: Icon(Icons.schedule, color: AppPalette.whiteColor),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
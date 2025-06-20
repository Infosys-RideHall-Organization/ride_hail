import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:ride_hail/features/driver/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:ride_hail/features/driver/presentation/widgets/bottom_sheet/ride_status_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/toast.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/fare_calculator.dart';
import '../../../../core/utils/google_maps_utility.dart';
import '../../../booking/presentation/bloc/booking/booking_bloc.dart';

class DriverMapPage extends StatefulWidget {
  const DriverMapPage({super.key});

  @override
  State<DriverMapPage> createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  io.Socket? socket;
  String darkMapTheme = '';
  String lightMapTheme = '';
  final Completer<GoogleMapController> _controller = Completer();
  final String baseUrl = Constants.baseUrl;
  bool socketInitialized = false;
  bool otpDialogShown = false;
  bool isCheckingDistance = false;
  bool otpVerified = false;
  BitmapDescriptor? buggyIcon;
  final otpController = TextEditingController();
  bool verifiedDialogShown = false;

  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};

  LatLng? _previousPosition; // Used for bearing

  List<LatLng> _driverToPickupCoords = [];

  late StreamSubscription<Position> positionSubscription;

  Future<void> loadBuggyIcon() async {
    buggyIcon = await GoogleMapsUtility.getBytesFromAsset(
      'assets/images/buggy-marker-icon-2x.png',
      20,
    );
  }

  void connectToSocket() {
    socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint("🚗 Driver connected to socket");
      final vehicleState = context.read<VehicleBloc>().state;
      if (vehicleState is VehicleLoaded) {
        socket!.emit("joinDriver", vehicleState.vehicle.id);

        // Join booking if there's an active booking
        final bookingState = context.read<BookingBloc>().state;
        if (bookingState.booking != null) {
          joinBookingRoom(bookingState.booking!.id);
        }
      }

      // Set up socket event listeners
      setupSocketListeners();
    });

    socket!.onDisconnect((_) => debugPrint("👎Disconnected from socket"));
  }

  void setupSocketListeners() {
    // Listen for location requests from users
    socket!.on('locationRequested', (data) {
      debugPrint("📍 Location requested for booking: ${data['bookingId']}");
      // Send current location immediately when requested
      sendCurrentLocation();
    });

    // Listen for any ride-related updates (optional, for debugging)
    socket!.on('rideStatusChanged', (data) {
      debugPrint(
        "Ride status changed: ${data['status']} for booking: ${data['bookingId']}",
      );
    });

    socket!.on('activeConnectionsInfo', (data) {
      debugPrint(" Active connections: $data");
    });

    socket!.on('cancelRide', (data) {
      debugPrint("Ride cancelled by user: $data");
      _showInfoDialog(
        title: 'Ride Cancelled',
        message: data['message'] ?? 'The user has cancelled the ride.',
      );
    });

    socket!.on('rideCancelled', (data) {
      debugPrint("Ride cancelled by user: $data");
      _showInfoDialog(
        title: 'Ride Cancelled',
        message: data['message'] ?? 'The user has cancelled the ride.',
      );
    });

    //  Emergency Stop triggered by user
    socket!.on('emergencyStop', (data) {
      debugPrint("Emergency stop triggered by user: $data");
      _showInfoDialog(
        title: 'Emergency Stop',
        message: data['message'] ?? 'The user triggered an emergency stop.',
      );
    });
  }

  void _showInfoDialog({required String title, required String message}) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppPalette.darkGreyColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppPalette.secondaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    Navigator.of(context).pop(); // Pop current screen
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void joinBookingRoom(String bookingId) {
    final vehicleState = context.read<VehicleBloc>().state;
    if (vehicleState is VehicleLoaded && socket?.connected == true) {
      socket!.emit('joinBooking', {
        'vehicleId': vehicleState.vehicle.id,
        'bookingId': bookingId,
      });
      debugPrint("Driver joined booking room: $bookingId");
    }
  }

  void sendCurrentLocation() async {
    try {
      final vehicleState = context.read<VehicleBloc>().state;
      final position = await Geolocator.getCurrentPosition();
      if (vehicleState is VehicleLoaded && socket?.connected == true) {
        socket!.emit('sendLocation', {
          'vehicleId': vehicleState.vehicle.id,
          'location': {'lat': position.latitude, 'lng': position.longitude},
        });
        debugPrint(
          "📍 Sent current location: ${position.latitude}, ${position.longitude}",
        );
      }
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  void sendOtpVerificationStatus({
    required String bookingId,
    required bool otpVerified,
    String? message,
  }) {
    final vehicleState = context.read<VehicleBloc>().state;
    if (vehicleState is VehicleLoaded && socket?.connected == true) {
      socket!.emit('otpVerified', {
        'bookingId': bookingId,
        'vehicleId': vehicleState.vehicle.id,
        'otpVerified': otpVerified,
        'message': message,
      });
      debugPrint(
        "Sent OTP verification status: $otpVerified for booking: $bookingId",
      );
    }
  }

  void sendRideStatusUpdate({
    required String bookingId,
    required String status,
    String? message,
  }) {
    final vehicleState = context.read<VehicleBloc>().state;
    if (vehicleState is VehicleLoaded && socket?.connected == true) {
      socket!.emit('rideStatusUpdate', {
        'bookingId': bookingId,
        'vehicleId': vehicleState.vehicle.id,
        'status': status,
        'message': message,
      });
      debugPrint(" Sent ride status update: $status for booking: $bookingId");
    }
  }

  void notifyDriverArrived({
    required String bookingId,
    required LatLng location,
  }) {
    final vehicleState = context.read<VehicleBloc>().state;
    if (vehicleState is VehicleLoaded && socket?.connected == true) {
      socket!.emit('driverArrived', {
        'bookingId': bookingId,
        'vehicleId': vehicleState.vehicle.id,
        'location': {'lat': location.latitude, 'lng': location.longitude},
      });
      debugPrint("Notified driver arrived for booking: $bookingId");
    }
  }

  void notifyRideCompleted({
    required String bookingId,
    Map<String, dynamic>? completionData,
  }) {
    final vehicleState = context.read<VehicleBloc>().state;
    if (vehicleState is VehicleLoaded && socket?.connected == true) {
      socket!.emit('rideCompleted', {
        'bookingId': bookingId,
        'vehicleId': vehicleState.vehicle.id,
        'completionData': completionData ?? {},
      });
      debugPrint("Notified ride completed for booking: $bookingId");
    }
  }

  void getActiveConnections() {
    if (socket?.connected == true) {
      socket!.emit('getActiveConnections');
    }
  }

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/map_themes/dark-theme.json')
        .then((value) => darkMapTheme = value);
    DefaultAssetBundle.of(context)
        .loadString('assets/map_themes/light-theme.json')
        .then((value) => lightMapTheme = value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleBloc>().add(GetVehicleByDriverId());
      loadBuggyIcon();
      connectToSocket();
      initializePickUpAndDestinationMarker();
      initialPickUpToDestinationPolyLines();
      initializeMyLocationMarker();
      trackBuggyLocation();
      initialiseDriverToPickUpPolyLine();
      initCampus();
    });
  }

  void initCampus() {
    final campusLatLng = context.read<BookingBloc>().state.booking?.campus;
    debugPrint(context.read<BookingBloc>().state.toString());
    campus = CameraPosition(
      target: LatLng(campusLatLng!.latitude, campusLatLng.longitude),
      zoom: 17,
    );
    setState(() {});
  }

  Future<void> showOtpDialog() async {
    setState(() {
      otpDialogShown = true;
    });

    final bookingState = context.read<BookingBloc>().state;
    final expectedOtp = bookingState.booking?.otp;

    if (expectedOtp == null || expectedOtp.isEmpty) {
      showToast(
        context: context,
        type: ToastificationType.error,
        description: 'Error: Cannot verify OTP. Please contact support.',
      );
      setState(() {
        otpDialogShown = false;
      });
      return;
    }

    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Verify OTP'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please verify the OTP to start your ride.'),
                const SizedBox(height: 16),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final enteredOtp = otpController.text.trim();
                  if (enteredOtp == expectedOtp) {
                    context.read<BookingBloc>().add(VerifyOtp(enteredOtp));
                    setState(() {
                      otpVerified = true;
                    });

                    // Send OTP verification status to backend
                    sendOtpVerificationStatus(
                      bookingId: bookingState.booking!.id,
                      otpVerified: true,
                      message:
                          'OTP verified successfully! Your ride has started.',
                    );

                    // Update ride status to started
                    sendRideStatusUpdate(
                      bookingId: bookingState.booking!.id,
                      status: 'started',
                      message: 'Ride has started',
                    );

                    context.read<BookingBloc>().add(
                      GetBookingByIdEvent(bookingState.booking!.id),
                    );
                    Navigator.pop(dialogContext);
                  } else {
                    // Send failed OTP verification
                    sendOtpVerificationStatus(
                      bookingId: bookingState.booking!.id,
                      otpVerified: false,
                      message: 'OTP verification failed. Please try again.',
                    );

                    showToast(
                      context: context,
                      type: ToastificationType.error,
                      description: 'Incorrect OTP, Please try again.',
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ],
          );
        },
      ).then((_) {
        otpController.clear();
        if (mounted) {
          setState(() {
            otpDialogShown = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          otpDialogShown = false;
        });
      }
    }
  }

  void manuallyTriggerOtpDialog() {
    if (!otpDialogShown && !otpVerified) {
      showOtpDialog();
    }
  }

  Future<void> initializeMyLocationMarker() async {
    final myPosition = await Geolocator.getCurrentPosition();
    Marker myLocationMarker = Marker(
      markerId: const MarkerId('my_location'),
      position: LatLng(myPosition.latitude, myPosition.longitude),
      icon: buggyIcon!,
      infoWindow: const InfoWindow(title: 'Your Location'),
    );
    if (mounted) {
      setState(() {
        markers.add(myLocationMarker);
      });
    }
  }

  void initializePickUpAndDestinationMarker() {
    final bookingState = context.read<BookingBloc>().state;
    final Marker pickUpMarker = Marker(
      markerId: const MarkerId('pickUp'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      position: LatLng(
        bookingState.booking!.origin.lat,
        bookingState.booking!.origin.lng,
      ),
    );

    final Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        bookingState.booking!.destination.lat,
        bookingState.booking!.destination.lng,
      ),
    );
    if (mounted) {
      setState(() {
        markers.addAll({pickUpMarker, destinationMarker});
      });
    }
  }

  Future<void> initialPickUpToDestinationPolyLines() async {
    final bookingState = context.read<BookingBloc>().state;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.mapKey,
      request: PolylineRequest(
        origin: PointLatLng(
          bookingState.booking!.origin.lat,
          bookingState.booking!.origin.lng,
        ),
        destination: PointLatLng(
          bookingState.booking!.destination.lat,
          bookingState.booking!.destination.lng,
        ),
        mode: TravelMode.driving,
      ),
    );
    final polylineCoordinates =
        result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
    final polyline = Polyline(
      polylineId: const PolylineId('pickUpToDestination'),
      points: polylineCoordinates,
      color: AppPalette.secondaryColor,
      width: 5,
    );
    if (mounted) {
      setState(() {
        polyLines.add(polyline);
      });
    }
  }

  Future<void> fitCameraToBounds(LatLng origin, LatLng destination) async {
    final controller = await _controller.future;
    final bounds = LatLngBounds(
      southwest: LatLng(
        math.min(origin.latitude, destination.latitude),
        math.min(origin.longitude, destination.longitude),
      ),
      northeast: LatLng(
        math.max(origin.latitude, destination.latitude),
        math.max(origin.longitude, destination.longitude),
      ),
    );
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 80);
    controller.animateCamera(cameraUpdate);
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1 = start.latitude * (math.pi / 180);
    final double lon1 = start.longitude * (math.pi / 180);
    final double lat2 = end.latitude * (math.pi / 180);
    final double lon2 = end.longitude * (math.pi / 180);

    final double dLon = lon2 - lon1;
    final double y = math.sin(dLon) * math.cos(lat2);
    final double x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    final double bearing = math.atan2(y, x);

    return (bearing * (180 / math.pi) + 360) % 360;
  }

  Future<void> initialiseDriverToPickUpPolyLine() async {
    final bookingState = context.read<BookingBloc>().state;
    final myPosition = await Geolocator.getCurrentPosition();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.mapKey,
      request: PolylineRequest(
        origin: PointLatLng(myPosition.latitude, myPosition.longitude),
        destination: PointLatLng(
          bookingState.booking!.origin.lat,
          bookingState.booking!.origin.lng,
        ),
        mode: TravelMode.driving,
      ),
    );

    _driverToPickupCoords =
        result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

    final driverPoly = Polyline(
      polylineId: const PolylineId('driverToPickUp'),
      points: _driverToPickupCoords,
      color: AppPalette.secondaryColor,
      width: 5,
      patterns: [PatternItem.dot, PatternItem.gap(10)],
    );

    if (mounted) {
      setState(() {
        polyLines.removeWhere((p) => p.polylineId.value == 'driverToPickUp');
        polyLines.add(driverPoly);
      });
      await fitCameraToBounds(
        _driverToPickupCoords.first,
        _driverToPickupCoords.last,
      );
    }
  }

  void trackBuggyLocation() {
    positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (!mounted || buggyIcon == null) return;

      final LatLng newPosition = LatLng(position.latitude, position.longitude);
      double bearing = 0;

      if (_previousPosition != null) {
        bearing = _calculateBearing(_previousPosition!, newPosition);
      }

      final Marker updatedBuggyMarker = Marker(
        markerId: const MarkerId('my_location'),
        position: newPosition,
        icon: buggyIcon!,
        infoWindow: const InfoWindow(title: 'Your Location'),
        rotation: bearing,
        anchor: const Offset(0.5, 0.5),
      );

      if (mounted) {
        setState(() {
          markers.removeWhere((m) => m.markerId.value == 'my_location');
          markers.add(updatedBuggyMarker);
          _previousPosition = newPosition;
        });

        _updateDriverToPickupPolyline(newPosition);

        // Check if driver is close to pickup location
        _checkProximityToPickup(newPosition);
      }

      final vehicleState = context.read<VehicleBloc>().state;
      if (vehicleState is VehicleLoaded &&
          socket?.connected == true &&
          mounted) {
        socket!.emit('sendLocation', {
          'vehicleId': vehicleState.vehicle.id,
          'location': {
            'lat': newPosition.latitude,
            'lng': newPosition.longitude,
          },
        });

        debugPrint(
          "📍 Updated driver location: ${newPosition.latitude}, ${newPosition.longitude}",
        );
      }
    });
  }

  void _checkProximityToPickup(LatLng currentLocation) {
    final bookingState = context.read<BookingBloc>().state;
    if (bookingState.booking == null) return;

    final pickupLocation = LatLng(
      bookingState.booking!.origin.lat,
      bookingState.booking!.origin.lng,
    );

    final distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      pickupLocation.latitude,
      pickupLocation.longitude,
    );

    // If driver is within 50 meters of pickup location, notify arrival
    if (distance <= 50 && !isCheckingDistance) {
      isCheckingDistance = true;
      notifyDriverArrived(
        bookingId: bookingState.booking!.id,
        location: currentLocation,
      );

      showToast(
        context: context,
        type: ToastificationType.success,
        description: 'You have arrived at the pickup location!',
      );

      // Reset the flag after a delay to prevent spam
      Timer(const Duration(seconds: 30), () {
        isCheckingDistance = false;
      });
    }
  }

  void _updateDriverToPickupPolyline(LatLng currentLocation) {
    if (_driverToPickupCoords.isEmpty) return;

    // Find index of closest point ahead of current location
    int closestIndex = _driverToPickupCoords.indexWhere((point) {
      return Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            point.latitude,
            point.longitude,
          ) <
          30;
    });

    if (closestIndex == -1) {
      // No close point found; keep full path
      closestIndex = 0;
    }

    final remainingPath = _driverToPickupCoords.sublist(closestIndex);

    final updatedPolyline = Polyline(
      polylineId: const PolylineId('driverToPickUp'),
      points: remainingPath,
      color: AppPalette.secondaryColor,
      width: 5,
      patterns: [PatternItem.dot, PatternItem.gap(10)],
    );

    if (mounted) {
      setState(() {
        polyLines.removeWhere((p) => p.polylineId.value == 'driverToPickUp');
        polyLines.add(updatedPolyline);
      });
    }
  }

  @override
  void dispose() {
    // Cancel subscription first to prevent any more callbacks
    positionSubscription.cancel();
    otpController.dispose();
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }

  CameraPosition? campus;

  @override
  Widget build(BuildContext context) {
    if (campus == null) {
      return Center(child: CustomLoadingIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                final themeState = context.watch<ThemeCubit>().state;
                return GoogleMap(
                  style:
                      themeState.appTheme == AppThemeMode.dark
                          ? darkMapTheme
                          : lightMapTheme,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  polylines: polyLines,
                  markers: markers,
                  myLocationEnabled: true,
                  initialCameraPosition: campus!,
                  onMapCreated:
                      (controller) => _controller.complete(controller),
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: RideStatusWidget(
        onVerifyOTP: () {
          manuallyTriggerOtpDialog();
        },
        finishRide: () {
          final bookingState = context.read<BookingBloc>().state;
          final start = bookingState.booking?.origin;
          final end = bookingState.booking?.destination;
          final double fare = FareCalculatorUtil.calculateFare(
            LatLng(start!.lat, start.lng),
            LatLng(end!.lat, end.lng),
            bookingState.passengers.length,
            bookingState.weightItems.length,
          );
          // Notify backend about ride completion
          if (bookingState.booking != null) {
            notifyRideCompleted(
              bookingId: bookingState.booking!.id,
              completionData: {
                'fare': fare,
                'completedAt': DateTime.now().toIso8601String(),
                'finalLocation': {
                  'lat': _previousPosition?.latitude,
                  'lng': _previousPosition?.longitude,
                },
              },
            );

            // Update ride status to completed
            sendRideStatusUpdate(
              bookingId: bookingState.booking!.id,
              status: 'completed',
              message: 'Ride has been completed successfully',
            );
          }

          // Finish ride
          showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                backgroundColor: AppPalette.darkGreyColor,
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppPalette.secondaryColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ride finished!',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((_) {
            if (context.mounted) {
              context.read<BookingBloc>().add(CompleteBooking());
              Navigator.pop(context);
            }
          });
        },
      ),
    );
  }
}

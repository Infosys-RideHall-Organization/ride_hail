import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:ride_hail/core/theme/cubit/theme_cubit.dart';
import 'package:ride_hail/features/booking/presentation/bloc/map/map_bloc.dart';
import 'package:ride_hail/features/booking/presentation/bloc/stage/booking_stage_cubit.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/assign_vehicle_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/booking_confirmed_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/confirm_pickup_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/en_route_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/passengers_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/schedule_trip_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/select_destination_widget.dart';
import 'package:ride_hail/features/booking/presentation/widgets/home/bottom_sheet/your_trip_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/toast.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/google_maps_utility.dart';
import '../bloc/booking/booking_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  String darkMapTheme = '';
  String lightMapTheme = '';
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition? campus;

  io.Socket? socket;

  Marker? driverMarker;
  LatLng? driverLatLng;
  LatLng? previousDriverLatLng;
  BitmapDescriptor? buggyIcon;

  // Animation controller for smooth driver movement
  AnimationController? _driverAnimationController;
  Animation<double>? _driverAnimation;
  LatLng? _animationStartPosition;
  LatLng? _animationEndPosition;
  double _currentBearing = 0.0;

  final String baseUrl = Constants.baseUrl;
  bool socketInitialized = false;

  // Socket connection state
  bool _isSocketConnected = false;
  Timer? _reconnectionTimer;
  int _reconnectionAttempts = 0;
  static const int maxReconnectionAttempts = 5;

  bool _verifiedDialogShown = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _driverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _driverAnimation = CurvedAnimation(
      parent: _driverAnimationController!,
      curve: Curves.easeInOut,
    );

    _driverAnimation!.addListener(() {
      if (_animationStartPosition != null && _animationEndPosition != null) {
        _updateAnimatedDriverPosition();
      }
    });

    DefaultAssetBundle.of(context)
        .loadString('assets/map_themes/dark-theme.json')
        .then((value) => darkMapTheme = value);
    DefaultAssetBundle.of(context)
        .loadString('assets/map_themes/light-theme.json')
        .then((value) => lightMapTheme = value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCampus();
      context.read<MapBloc>().add(LoadUserLocation());
      _loadBuggyIcon();
    });
  }

  Future<void> _loadBuggyIcon() async {
    buggyIcon = await GoogleMapsUtility.getBytesFromAsset(
      'assets/images/buggy-marker-icon-2x.png',
      20,
    );
  }

  void initCampus() {
    final campusLatLng = context.read<BookingBloc>().state.campus;
    campus = CameraPosition(
      target: LatLng(campusLatLng!.latitude, campusLatLng.longitude),
      zoom: 17,
    );
    setState(() {});
  }

  void _initializeSocket() {
    if (socket != null && _isSocketConnected) {
      debugPrint('Socket already connected, skipping initialization');
      return;
    }

    socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionAttempts(maxReconnectionAttempts)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(10000)
          .build(),
    );

    socket!.connect();
    debugPrint('Socket connecting...');

    socket!.onConnect((_) {
      debugPrint('Socket connected');
      _isSocketConnected = true;
      _reconnectionAttempts = 0;
      _reconnectionTimer?.cancel();

      // Join user with proper parameters
      final bookingState = context.read<BookingBloc>().state;
      final userId = bookingState.booking?.userId; // Assuming you have user ID
      final bookingId = bookingState.booking?.id;

      if (userId != null) {
        socket!.emit('joinUser', {'userId': userId, 'bookingId': bookingId});
        debugPrint('User joined with userId: $userId, bookingId: $bookingId');
      } else {
        // Fallback for when user ID is not available
        socket!.emit('joinUser', {});
        debugPrint('User joined without userId');
      }

      _setupSocketListeners();
    });

    socket!.onError((data) {
      debugPrint("Socket Error: $data");
      _isSocketConnected = false;
    });

    socket!.onDisconnect((reason) {
      debugPrint('Socket disconnected: $reason');
      _isSocketConnected = false;

      // Attempt reconnection if not manually disconnected
      if (reason != 'io client disconnect' &&
          _reconnectionAttempts < maxReconnectionAttempts) {
        _attemptReconnection();
      }
    });

    socket!.onConnectError((data) {
      debugPrint('Socket connection error: $data');
      _isSocketConnected = false;
      _attemptReconnection();
    });
  }

  void _attemptReconnection() {
    if (_reconnectionAttempts >= maxReconnectionAttempts) {
      debugPrint('Max reconnection attempts reached');
      return;
    }

    _reconnectionAttempts++;
    debugPrint(
      'Attempting reconnection $_reconnectionAttempts/$maxReconnectionAttempts',
    );

    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(
      Duration(seconds: _reconnectionAttempts * 2),
      () {
        if (!_isSocketConnected && mounted) {
          socket?.connect();
        }
      },
    );
  }

  void _setupSocketListeners() {
    // Driver location updates
    socket!.on('sendLocation', (data) {
      debugPrint('📍 Driver location update: $data');
      try {
        final lat = data['location']['lat'];
        final lng = data['location']['lng'];
        final vehicleId = data['vehicleId'];
        final newLatLng = LatLng(lat, lng);

        debugPrint(
          'Driver location - Vehicle: $vehicleId, Lat: $lat, Lng: $lng',
        );
        _updateDriverLocation(newLatLng);
      } catch (e) {
        debugPrint("Error parsing driver location: $e");
      }
    });

    // OTP verification status
    socket!.on('otpVerificationStatus', (data) {
      debugPrint('OTP verification status: $data');
      try {
        final bookingId = data['bookingId'];
        // final vehicleId = data['vehicleId'];
        final otpVerified = data['otpVerified'];
        final message = data['message'];

        if (otpVerified == true && _verifiedDialogShown == false) {
          _showOtpVerifiedDialog(message ?? 'OTP verified successfully!');
          setState(() {
            _verifiedDialogShown = true;
          });
          // Update booking state if needed
          // You might want to dispatch an event to update the booking status
          context.read<BookingBloc>().add(GetBookingByIdEvent(bookingId));
        }
      } catch (e) {
        debugPrint("Error handling OTP verification: $e");
      }
    });

    // Ride status changes
    socket!.on('rideStatusChanged', (data) {
      debugPrint(' Ride status changed: $data');
      try {
        //final status = data['status'];
        //final message = data['message'];
        final bookingId = data['bookingId'];
        // Update booking state based on status
        context.read<BookingBloc>().add(GetBookingByIdEvent(bookingId));
      } catch (e) {
        debugPrint("Error handling ride status change: $e");
      }
    });

    // Driver arrived at pickup
    socket!.on('driverArrivedAtPickup', (data) {
      debugPrint(' Driver arrived at pickup: $data');
      try {
        final message = data['message'];
        final location = data['location'];

        _showDriverArrivedDialog(message ?? 'Your driver has arrived!');

        // Update driver location if provided
        if (location != null &&
            location['lat'] != null &&
            location['lng'] != null) {
          final arrivedLocation = LatLng(location['lat'], location['lng']);
          _updateDriverLocation(arrivedLocation);
        }
      } catch (e) {
        debugPrint("Error handling driver arrival: $e");
      }
    });

    // Ride completed
    socket!.on('rideCompletedNotification', (data) {
      debugPrint('Ride completed: $data');
      try {
        final message = data['message'];
        final completionData = data['completionData'];

        _showRideCompletedDialog(
          message ?? 'Your ride has been completed successfully',
          completionData,
        );
      } catch (e) {
        debugPrint("Error handling ride completion: $e");
      }
    });

    // Active connections info (for debugging)
    socket!.on('activeConnectionsInfo', (data) {
      debugPrint('Active connections: $data');
    });
  }

  // UI Feedback Methods

  void _showOtpVerifiedDialog(String message) {
    if (!mounted) return;

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
                  Icons.verified,
                  color: AppPalette.secondaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Ride Verified!',
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
                    Navigator.of(dialogContext).pop();
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

  void _showDriverArrivedDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppPalette.darkGreyColor,
          title: Row(
            children: [
              Icon(Icons.location_on, color: AppPalette.secondaryColor),
              const SizedBox(width: 8),
              const Text('Driver Arrived'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRideCompletedDialog(String message, dynamic completionData) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppPalette.darkGreyColor,
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Ride Completed'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              if (completionData != null) ...[
                const SizedBox(height: 16),
                Text('Thank you for riding with us!'),
                // Optionally display completionData details:
                Text(
                  'Fare: ₹${(completionData['fare'] as double).toStringAsFixed(2)}',
                ),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Reset state and navigate back
                final bookingBloc = context.read<BookingBloc>();
                final mapBloc = context.read<MapBloc>();
                bookingBloc.add(ResetBooking());
                mapBloc.add(ResetMap());
                driverMarker = null;
                driverLatLng = null;
                socket?.disconnect();
                socket?.destroy();
                context.read<BookingStageCubit>().reset();
                Navigator.of(dialogContext).pop();
                context.pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * (math.pi / 180);
    final lat2 = end.latitude * (math.pi / 180);
    final deltaLng = (end.longitude - start.longitude) * (math.pi / 180);

    final y = math.sin(deltaLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);

    final bearing = math.atan2(y, x) * (180 / math.pi);
    return (bearing + 360) % 360;
  }

  // Interpolate between two LatLng points
  LatLng _interpolateLatLng(LatLng start, LatLng end, double t) {
    final lat = start.latitude + (end.latitude - start.latitude) * t;
    final lng = start.longitude + (end.longitude - start.longitude) * t;
    return LatLng(lat, lng);
  }

  void _updateAnimatedDriverPosition() {
    if (_animationStartPosition == null || _animationEndPosition == null) {
      return;
    }

    final currentPosition = _interpolateLatLng(
      _animationStartPosition!,
      _animationEndPosition!,
      _driverAnimation!.value,
    );

    setState(() {
      driverLatLng = currentPosition;
      driverMarker = Marker(
        markerId: const MarkerId('driver'),
        position: currentPosition,
        icon:
            buggyIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: _currentBearing,
        infoWindow: const InfoWindow(title: 'Your Ride'),
      );
    });
  }

  Future<List<LatLng>> _getDottedPolylinePoints(LatLng from, LatLng to) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.mapKey,
      request: PolylineRequest(
        origin: PointLatLng(from.latitude, from.longitude),
        destination: PointLatLng(to.latitude, to.longitude),
        mode: TravelMode.driving,
      ),
    );

    return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  void _updateDriverLocation(LatLng newPosition) async {
    final state = context.read<MapBloc>().state;
    final controller = await _controller.future;

    // Calculate bearing if we have a previous position
    if (previousDriverLatLng != null) {
      _currentBearing = _calculateBearing(previousDriverLatLng!, newPosition);
    }

    // Set up animation
    _animationStartPosition = driverLatLng ?? newPosition;
    _animationEndPosition = newPosition;
    previousDriverLatLng = driverLatLng;

    // Start the smooth animation
    _driverAnimationController?.reset();
    _driverAnimationController?.forward();

    // Smoothly animate camera to follow driver
    controller.animateCamera(CameraUpdate.newLatLng(newPosition));

    if (state.origin != null) {
      final dottedPath = await _getDottedPolylinePoints(
        newPosition,
        state.origin!,
      );

      final Set<Polyline> updatedPolylines =
          Set<Polyline>.from(state.polylines)
            ..removeWhere((poly) => poly.polylineId.value == 'driver_to_user')
            ..add(
              Polyline(
                polylineId: const PolylineId('driver_to_user'),
                color: AppPalette.secondaryColor,
                points: dottedPath,
                width: 5,
                patterns: [PatternItem.dot, PatternItem.gap(10)],
              ),
            );

      if (mounted) {
        context.read<MapBloc>().add(
          UpdatePolylines(
            polylineCoordinates: dottedPath,
            polylines: updatedPolylines,
          ),
        );
      }
    }
  }

  Future<void> _getPolyLines(MapState state) async {
    if (state.origin == null || state.destination == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Constants.mapKey,
      request: PolylineRequest(
        origin: PointLatLng(state.origin!.latitude, state.origin!.longitude),
        destination: PointLatLng(
          state.destination!.latitude,
          state.destination!.longitude,
        ),
        mode: TravelMode.driving,
      ),
    );

    final List<LatLng> polylineCoordinates =
        result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

    final Set<Polyline> polyLines = {
      Polyline(
        polylineId: const PolylineId('route'),
        color: AppPalette.secondaryColor,
        points: polylineCoordinates,
        width: 6,
        patterns: [PatternItem.dot, PatternItem.gap(15)],
      ),
    };

    if (mounted) {
      context.read<MapBloc>().add(
        UpdatePolylines(
          polylineCoordinates: polylineCoordinates,
          polylines: polyLines,
        ),
      );
    }

    await _fitCameraToBounds(state.origin!, state.destination!);
  }

  Future<void> _fitCameraToBounds(LatLng origin, LatLng destination) async {
    final controller = await _controller.future;
    final bounds = LatLngBounds(
      southwest: LatLng(
        origin.latitude < destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude < destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
      northeast: LatLng(
        origin.latitude > destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude > destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
    );
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 80);
    controller.animateCamera(cameraUpdate);
  }

  Future<void> _searchPlace(String value) async {
    if (value.isNotEmpty) {
      context.read<MapBloc>().add(SearchPlaces(value));
    } else {
      context.read<MapBloc>().add(ClearSearchResults());
    }
  }

  @override
  void dispose() {
    _driverAnimationController?.dispose();
    _reconnectionTimer?.cancel();

    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (campus == null) {
      return Center(child: CustomLoadingIndicator());
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<BookingBloc, BookingState>(
            listenWhen:
                (previous, current) =>
                    (previous.booking?.status == 'unverified') &&
                    (current.booking?.status == 'verified'),
            listener: (context, state) {},
            child: Stack(
              children: [
                BlocListener<BookingStageCubit, BookingStageState>(
                  listener: (context, stageState) {
                    if (stageState.stage == BookingStage.enRoute &&
                        !socketInitialized) {
                      socketInitialized = true;
                      _initializeSocket();

                      setState(() {
                        _verifiedDialogShown = false;
                      });
                    }
                  },
                  child: Builder(
                    builder: (context) {
                      final themeState = context.watch<ThemeCubit>().state;
                      final mapState = context.watch<MapBloc>().state;

                      final markers = Set<Marker>.from(mapState.markers);
                      if (driverMarker != null) markers.add(driverMarker!);

                      return GoogleMap(
                        style:
                            themeState.appTheme == AppThemeMode.dark
                                ? darkMapTheme
                                : lightMapTheme,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        polylines: mapState.polylines,
                        markers: markers,
                        myLocationEnabled: true,
                        initialCameraPosition: campus!,
                        onMapCreated:
                            (controller) => _controller.complete(controller),
                      );
                    },
                  ),
                ),
                // Back button
                BlocBuilder<BookingStageCubit, BookingStageState>(
                  builder: (context, stageState) {
                    if (stageState.stage != BookingStage.selectDestination) {
                      return Positioned(
                        top: 16,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              context.read<BookingStageCubit>().previousStage();
                            },
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Loading overlay
                Builder(
                  builder: (context) {
                    final mapLoading = context.select(
                      (MapBloc bloc) => bloc.state.loading,
                    );
                    final bookingLoading = context.select(
                      (BookingBloc bloc) => bloc.state.loading,
                    );

                    final isLoading = mapLoading || bookingLoading;

                    if (!isLoading) return const SizedBox.shrink();

                    return Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: Container(
                          color: Colors.black.withAlpha(100),
                          alignment: Alignment.center,
                          child: const CustomLoadingIndicator(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BlocBuilder<BookingStageCubit, BookingStageState>(
          builder: (context, stageState) {
            switch (stageState.stage) {
              case BookingStage.selectDestination:
                return SelectDestinationWidget(
                  getPolyLines: _getPolyLines,
                  searchPlace: _searchPlace,
                );
              case BookingStage.confirmPickup:
                return const ConfirmPickupWidget();
              case BookingStage.yourTrip:
                return const YourTripWidget();
              case BookingStage.addPassengers:
                return const PassengersWidget();
              case BookingStage.scheduleTrip:
                return const ScheduleTripWidget();
              case BookingStage.bookingConfirmed:
                return const BookingConfirmedWidget();
              case BookingStage.assignVehicle:
                return const AssignVehicleWidget();
              case BookingStage.enRoute:
                return EnRouteWidget(
                  onCancelled: () async {
                    try {
                      final bookingBloc = context.read<BookingBloc>();
                      final mapBloc = context.read<MapBloc>();
                      final bookingStageCubit =
                          context.read<BookingStageCubit>();
                      final bookingState = bookingBloc.state;

                      if (bookingState.booking == null) {
                        debugPrint(" No booking found to cancel");
                        return;
                      }

                      final booking = bookingState.booking!;

                      if (socket?.connected == true) {
                        debugPrint("📤 Sending ride cancellation to server...");

                        socket!.emit('cancelRide', {
                          'bookingId': booking.id,
                          'userId': booking.userId,
                          'message': 'Ride cancelled by user',
                        });

                        debugPrint(
                          " Cancellation event sent for booking: ${booking.id}",
                        );
                      } else {
                        debugPrint(
                          "⚠ Socket not connected, proceeding with local cancellation",
                        );
                      }

                      try {
                        bookingBloc.add(CancelBooking());
                        await Future.delayed(const Duration(milliseconds: 500));
                      } catch (e) {
                        debugPrint(" API cancellation failed: $e");
                      }

                      bookingBloc.add(ResetBooking());
                      mapBloc.add(ResetMap());
                      bookingStageCubit.reset();

                      setState(() {
                        driverMarker = null;
                        driverLatLng = null;
                        previousDriverLatLng = null;
                      });

                      if (socket != null) {
                        socket!.disconnect();
                        socket!.dispose();
                        socket = null;
                        socketInitialized = false;
                        _isSocketConnected = false;
                      }

                      _reconnectionTimer?.cancel();

                      if (context.mounted) {
                        showToast(
                          context: context,
                          type: ToastificationType.success,
                          description: 'Ride cancelled successfully!',
                        );

                        context.pop();
                      }
                    } catch (e) {
                      debugPrint("Error during ride cancellation: $e");

                      if (context.mounted && Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }

                      if (context.mounted) {
                        showToast(
                          context: context,
                          type: ToastificationType.error,
                          description:
                              'Failed to cancel ride. Please try again.',
                        );
                      }
                    }
                  },
                  onEmergencyStop: () async {
                    try {
                      final bookingBloc = context.read<BookingBloc>();
                      final mapBloc = context.read<MapBloc>();
                      final bookingStageCubit =
                          context.read<BookingStageCubit>();
                      final bookingState = bookingBloc.state;

                      if (bookingState.booking == null) {
                        debugPrint("No booking found to cancel");
                        return;
                      }
                      final booking = bookingState.booking!;

                      if (socket?.connected == true) {
                        debugPrint(
                          "📤 Sending ride emergency stops to server...",
                        );

                        socket!.emit('emergencyStop', {
                          'bookingId': booking.id,
                          'userId': booking.userId,
                          'message': 'Ride cancelled by user',
                        });

                        debugPrint(
                          "Emergency Stop event sent for booking: ${booking.id}",
                        );
                      } else {
                        debugPrint(
                          "⚠Socket not connected, proceeding with local cancellation",
                        );
                      }

                      try {
                        await Future.delayed(const Duration(milliseconds: 500));
                      } catch (e) {
                        debugPrint("️API cancellation failed: $e");
                      }

                      bookingBloc.add(ResetBooking());
                      mapBloc.add(ResetMap());
                      bookingStageCubit.reset();

                      setState(() {
                        driverMarker = null;
                        driverLatLng = null;
                        previousDriverLatLng = null;
                      });

                      if (socket != null) {
                        socket!.disconnect();
                        socket!.dispose();
                        socket = null;
                        socketInitialized = false;
                        _isSocketConnected = false;
                      }

                      _reconnectionTimer?.cancel();

                      if (context.mounted) {
                        showToast(
                          context: context,
                          type: ToastificationType.success,
                          description: 'Emergency Stop successfully!',
                        );
                        context.pop();
                      }
                    } catch (e) {
                      debugPrint("Error during emergency stop: $e");
                      if (context.mounted && Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                      if (context.mounted) {
                        showToast(
                          context: context,
                          type: ToastificationType.error,
                          description:
                              'Failed to emergency stop ride. Please try again.',
                        );
                      }
                    }
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ride_hail/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:ride_hail/features/booking/presentation/bloc/map/map_bloc.dart';
import 'package:ride_hail/features/booking/presentation/bloc/stage/booking_stage_cubit.dart';
import 'package:toastification/toastification.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/constants/constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'features/booking/presentation/bloc/activity/activity_bloc.dart';
import 'features/booking/presentation/bloc/campus/campus_bloc.dart';
import 'features/driver/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'firebase_options.dart';
import 'init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env variables
  await dotenv.load(fileName: '.env');

  // Hydrated Bloc Setup
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize OneSignal BEFORE runApp
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(Constants.oneSignalAppId);

  // Request permission and wait for it
  await OneSignal.Notifications.requestPermission(true);

  // Wait a bit for OneSignal to fully initialize
  await Future.delayed(const Duration(milliseconds: 500));

  // Set up code dependencies
  await initDependencies();

  // Initialize the internet connection listener
  initializeInternetListener();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AppUserCubit>()),
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<ProfileBloc>()),
        BlocProvider(create: (context) => getIt<MapBloc>()),
        BlocProvider(create: (context) => getIt<BookingStageCubit>()),
        BlocProvider(create: (context) => getIt<BookingBloc>()),
        BlocProvider(create: (context) => getIt<ActivityBloc>()),
        BlocProvider(create: (context) => getIt<CampusBloc>()),
        BlocProvider(create: (context) => getIt<VehicleBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _playerIdTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // Check if user is signed in
      context.read<AuthBloc>().add(AuthIsUserSignedIn());

      // Setup OneSignal player ID handling
      _setupOneSignalPlayerId();

      // Setup OneSignal notification action handler
      _setupOneSignalNotificationListener();
    });
  }

  void _setupOneSignalNotificationListener() {
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      final actionId = event.result.actionId;

      debugPrint('Notification clicked. Action ID: $actionId');
      debugPrint('Notification data: $data');

      if (actionId == 'accept' &&
          data != null &&
          data.containsKey('bookingId')) {
        final bookingId = data['bookingId'];
        _handleAcceptBooking(bookingId);
      }
    });
  }

  void _handleAcceptBooking(String bookingId) {
    debugPrint("Booking accepted for ID: $bookingId");

    // Example: Dispatch event to BookingBloc
    //  context.read<BookingBloc>().add(AcceptBookingEvent(bookingId: bookingId));

    // Optionally: Navigate to booking detail screen
    // Navigator.of(context).pushNamed('/booking_details', arguments: bookingId);
  }

  void _setupOneSignalPlayerId() {
    // Method 1: Try to get existing player ID immediately
    _tryGetPlayerId();

    // Method 2: Set up observer for future changes
    OneSignal.User.pushSubscription.addObserver((subscription) async {
      final playerId = subscription.current.id;
      debugPrint("OneSignal playerId received via observer: $playerId");

      if (playerId != null && playerId.isNotEmpty) {
        await _savePlayerId(playerId);
      }
    });

    // Method 3: Polling fallback (cancel after getting ID or timeout)
    _startPlayerIdPolling();
  }

  void _tryGetPlayerId() async {
    try {
      final playerId = OneSignal.User.pushSubscription.id;

      debugPrint("OneSignal current playerId: $playerId");

      if (playerId != null && playerId.isNotEmpty) {
        await _savePlayerId(playerId);
        _playerIdTimer?.cancel();
      }
    } catch (e) {
      debugPrint("Error getting OneSignal playerId: $e");
    }
  }

  void _startPlayerIdPolling() {
    int attempts = 0;
    const maxAttempts = 20; // Try for 10 seconds (500ms * 20)

    _playerIdTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      attempts++;

      if (attempts >= maxAttempts) {
        debugPrint(
          "OneSignal playerId polling timeout after $maxAttempts attempts",
        );
        timer.cancel();
        return;
      }

      _tryGetPlayerId();
    });
  }

  Future<void> _savePlayerId(String playerId) async {
    try {
      if (!mounted) return;

      debugPrint("Saving OneSignal playerId: $playerId");

      // Update profile bloc with player ID
      context.read<ProfileBloc>().add(UpdatePlayerId(playerId: playerId));

      // Save to secure storage
      await const FlutterSecureStorage().write(
        key: Constants.playerIdKey,
        value: playerId,
      );

      // Cancel polling timer since we got the ID
      _playerIdTimer?.cancel();
    } catch (e) {
      debugPrint("Error saving OneSignal playerId: $e");
    }
  }

  @override
  void dispose() {
    _playerIdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            title: 'Ride Hail App',
            debugShowCheckedModeBanner: false,
            theme:
                state.appTheme == AppThemeMode.dark
                    ? AppTheme.darkThemeMode
                    : AppTheme.lightThemeMode,
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}

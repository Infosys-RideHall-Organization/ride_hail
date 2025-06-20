import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ride_hail/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ride_hail/core/routes/go_router_refresh_stream.dart';
import 'package:ride_hail/features/booking/presentation/pages/activity_page.dart';
import 'package:ride_hail/features/booking/presentation/pages/home_page.dart';
import 'package:ride_hail/features/booking/presentation/pages/map_page.dart';
import 'package:ride_hail/features/booking/presentation/pages/services_page.dart';
import 'package:ride_hail/features/driver/presentation/pages/driver_home_page.dart';
import 'package:ride_hail/features/profile/presentation/pages/about_page.dart';
import 'package:ride_hail/features/profile/presentation/pages/change_password_page.dart';
import 'package:ride_hail/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:ride_hail/features/profile/presentation/pages/faq_page.dart';
import 'package:ride_hail/features/profile/presentation/pages/profile_page.dart';
import 'package:ride_hail/features/profile/presentation/pages/terms_and_conditions_page.dart';
import 'package:ride_hail/init_dependencies.dart';

import '../../core/common/pages/no_internet_page.dart'; // Add this import
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/verify_email_otp_page.dart';
import '../../features/auth/presentation/pages/verify_reset_otp_page.dart';
import '../../features/booking/presentation/pages/location_gate_page.dart';
import '../../features/driver/presentation/pages/driver_map_page.dart';
import '../../features/driver/presentation/pages/driver_profile_page.dart';
import '../../features/driver/presentation/pages/driver_vehicle_page.dart';
import 'app_routes.dart';
import 'driver_scaffold.dart';
import 'user_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _servicesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'services');
final _activityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'activity');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
final _driverHomeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'driver_home',
);
final _driverVehicleNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'driver_vehicle',
);
final _driverProfileNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'driver_profile',
);

// Internet connection notifier
final ValueNotifier<bool> _internetConnectionNotifier = ValueNotifier<bool>(
  true,
);

// Initialize internet connection listener
void initializeInternetListener() {
  InternetConnection().onStatusChange.listen((InternetStatus status) {
    _internetConnectionNotifier.value = status == InternetStatus.connected;
  });
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.signIn,
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  refreshListenable: Listenable.merge([
    GoRouterRefreshStream(getIt<AppUserCubit>().stream),
    _internetConnectionNotifier,
  ]),
  redirect: (context, state) async {
    final appState = getIt<AppUserCubit>().state;
    final isAuthPage = [
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.forgotPassword,
      AppRoutes.verifyEmailOtp,
      AppRoutes.verifyResetOtp,
      AppRoutes.resetPassword,
    ].contains(state.matchedLocation);

    // Check internet connection first
    final hasInternet = _internetConnectionNotifier.value;
    final isNoInternetPage = state.matchedLocation == AppRoutes.noInternet;

    // If no internet and not already on no internet page, redirect
    if (!hasInternet && !isNoInternetPage) {
      return AppRoutes.noInternet;
    }

    // If has internet and currently on no internet page, redirect appropriately
    if (hasInternet && isNoInternetPage) {
      if (appState is AppUserInitial) {
        return AppRoutes.signIn;
      } else if (appState is AppUserLoggedIn) {
        final role = appState.user.role;
        return role == "driver" ? AppRoutes.driverHome : AppRoutes.home;
      }
    }

    // If on no internet page, don't do further checks
    if (isNoInternetPage) {
      return null;
    }

    // Location permission check
    final locationPermissionGranted = await Geolocator.checkPermission().then(
      (status) =>
          status == LocationPermission.always ||
          status == LocationPermission.whileInUse,
    );

    if (appState is AppUserInitial) {
      return isAuthPage ? null : AppRoutes.signIn;
    } else if (appState is AppUserLoggedIn) {
      final role = appState.user.role;

      if (isAuthPage) {
        return role == "driver" ? AppRoutes.driverHome : AppRoutes.home;
      }

      final goingToGate = state.matchedLocation == AppRoutes.locationGate;

      // If location not granted and not on gate page, redirect to gate
      if (!locationPermissionGranted && !goingToGate) {
        return AppRoutes.locationGate;
      }

      // If location granted and currently on gate, redirect to home
      if (locationPermissionGranted && goingToGate) {
        return role == "driver" ? AppRoutes.driverHome : AppRoutes.home;
      }

      // Ensure driver doesn't land on user home and vice versa
      if (role == "driver" && state.matchedLocation == AppRoutes.home) {
        return AppRoutes.driverHome;
      } else if (role == "user" &&
          state.matchedLocation == AppRoutes.driverHome) {
        return AppRoutes.home;
      }
    }

    return null;
  },
  routes: [
    /// No Internet Page
    GoRoute(
      path: AppRoutes.noInternet,
      builder: (_, __) => const NoInternetPage(),
    ),

    /// Public / Auth routes
    GoRoute(path: AppRoutes.signUp, builder: (_, __) => const SignUpPage()),
    GoRoute(path: AppRoutes.signIn, builder: (_, __) => const SignInPage()),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, __) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmailOtp,
      builder: (_, __) => const VerifyEmailOtpPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyResetOtp,
      builder: (_, __) => const VerifyResetOtpPage(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (_, __) => const ResetPasswordPage(),
    ),

    // Location permission gate
    GoRoute(
      path: AppRoutes.locationGate,
      builder: (_, __) => const LocationGatePage(),
    ),

    /// Shell route for authenticated USER flow with bottom nav
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return UserScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, __) => const HomePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.map,
                  builder: (_, __) => const MapPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _servicesNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.services,
              builder: (_, __) => const ServicesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _activityNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.activity,
              builder: (_, __) => const ActivityPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.editProfile,
                  builder: (_, __) => const EditProfilePage(),
                ),
                GoRoute(
                  path: AppRoutes.about,
                  builder: (_, __) => const AboutPage(),
                ),
                GoRoute(
                  path: AppRoutes.termsAndConditions,
                  builder: (_, __) => const TermsAndConditionsPage(),
                ),
                GoRoute(
                  path: AppRoutes.faq,
                  builder: (_, __) => const FAQPage(),
                ),
                GoRoute(
                  path: AppRoutes.changePassword,
                  builder: (_, __) => const ChangePasswordPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    /// Driver shell route
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DriverScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _driverHomeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.driverHome,
              builder: (_, __) => const DriverHomePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.driverMap,
                  builder: (_, __) => const DriverMapPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _driverVehicleNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.vehicle,
              builder: (_, __) => const DriverVehiclePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _driverProfileNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.driverProfile,
              builder: (_, __) => const DriverProfilePage(),
              routes: [
                GoRoute(
                  path: AppRoutes.editProfile,
                  builder: (_, __) => const EditProfilePage(),
                ),
                GoRoute(
                  path: AppRoutes.about,
                  builder: (_, __) => const AboutPage(),
                ),
                GoRoute(
                  path: AppRoutes.termsAndConditions,
                  builder: (_, __) => const TermsAndConditionsPage(),
                ),
                GoRoute(
                  path: AppRoutes.faq,
                  builder: (_, __) => const FAQPage(),
                ),
                GoRoute(
                  path: AppRoutes.changePassword,
                  builder: (_, __) => const ChangePasswordPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

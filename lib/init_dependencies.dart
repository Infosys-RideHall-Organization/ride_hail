import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:ride_hail/features/auth/domain/usecases/remote_auth_usecases/sign_out.dart';
import 'package:ride_hail/features/booking/data/datasources/map/map_remote_data_source.dart';
import 'package:ride_hail/features/booking/data/repositories/map/map_repository_impl.dart';
import 'package:ride_hail/features/booking/domain/repositories/map/map_repository.dart';
import 'package:ride_hail/features/booking/domain/usecases/activity/get_past_bookings.dart';
import 'package:ride_hail/features/booking/domain/usecases/activity/get_upcoming_bookings.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/assign_vehicle.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/cancel_booking.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/complete_booking.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/create_booking.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/emergency_stop.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/get_booking_by_id.dart';
import 'package:ride_hail/features/booking/domain/usecases/booking/verify_otp.dart';
import 'package:ride_hail/features/booking/domain/usecases/map/get_address.dart';
import 'package:ride_hail/features/booking/domain/usecases/map/get_coordinates_from_place_id.dart';
import 'package:ride_hail/features/booking/domain/usecases/map/get_directions.dart';
import 'package:ride_hail/features/booking/domain/usecases/map/get_place_from_name.dart';
import 'package:ride_hail/features/booking/presentation/bloc/activity/activity_bloc.dart';
import 'package:ride_hail/features/booking/presentation/bloc/campus/campus_bloc.dart';
import 'package:ride_hail/features/booking/presentation/bloc/stage/booking_stage_cubit.dart';
import 'package:ride_hail/features/driver/domain/usecases/vehicle/get_vehicle_by_driver_id.dart';
import 'package:ride_hail/features/profile/domain/usecases/delete_profile.dart';
import 'package:ride_hail/features/profile/domain/usecases/get_profile.dart';
import 'package:ride_hail/features/profile/domain/usecases/update_player_id.dart';
import 'package:ride_hail/features/profile/domain/usecases/update_profile.dart';
import 'package:ride_hail/features/profile/presentation/bloc/profile_bloc.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/constants/constants.dart';
import 'core/services/secure_storage/secure_storage_service.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/current_user.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/email_verification.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/forgot_password.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/reset_password.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/reset_password_verification.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/reset_password_with_id.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/signin.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/signin_with_google.dart';
import 'features/auth/domain/usecases/remote_auth_usecases/signup.dart';
import 'features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'features/booking/data/datasources/booking/booking_remote_data_source.dart';
import 'features/booking/data/datasources/campus/campus_remote_datasource.dart';
import 'features/booking/data/repositories/booking/booking_repository_impl.dart';
import 'features/booking/data/repositories/campus/campus_repository_impl.dart';
import 'features/booking/domain/repositories/booking/booking_repository.dart';
import 'features/booking/domain/repositories/campus/campus_repository.dart';
import 'features/booking/domain/usecases/campus/get_all_campuses.dart';
import 'features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'features/booking/presentation/bloc/map/map_bloc.dart';
import 'features/driver/data/datasources/vehicle/vehicle_remote_data_source.dart';
import 'features/driver/data/repositories/vehicle/vehicle_repository_impl.dart';
import 'features/driver/domain/repositories/vehicle/vehicle_repository.dart';
import 'features/driver/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';

//global instance of get_it
final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  //Theme
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // AppUser
  getIt.registerLazySingleton<AppUserCubit>(() => AppUserCubit());

  //initialize flutter secure storage singleton
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  // initialize secure storage service
  getIt.registerCachedFactory<SecureStorageService>(
    () => SecureStorageServiceImpl(storage: getIt<FlutterSecureStorage>()),
  );

  // initialise auth
  _initAuth();
  // initialise profile
  _initProfile();
  // initialise booking
  _initBooking();
  // initialise campus
  _initCampus();
  // initialise activity
  _initActivity();
  // initialise driver vehicle
  _initVehicle();
}

// All Authentication Objects
void _initAuth() {
  // initialize auth local data source
  getIt.registerCachedFactory<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );

  // initialize auth remote data source
  getIt.registerCachedFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // initialize auth repository with auth data sources
  getIt.registerCachedFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      authLocalDataSource: getIt<AuthLocalDataSource>(),
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  // initialize auth repository with auth data sources

  //Auth Bloc use cases
  getIt.registerCachedFactory<SignupUsecase>(
    () => SignupUsecase(authRepository: getIt.get<AuthRepository>()),
  );
  getIt.registerCachedFactory<SigninUsecase>(
    () => SigninUsecase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerCachedFactory<SigninWithGoogleUsecase>(
    () => SigninWithGoogleUsecase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerCachedFactory<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerCachedFactory<ResetPasswordVerificationUsecase>(
    () => ResetPasswordVerificationUsecase(
      authRepository: getIt<AuthRepository>(),
    ),
  );
  getIt.registerCachedFactory<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerCachedFactory<ResetPasswordWithIdUsecase>(
    () => ResetPasswordWithIdUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerCachedFactory<EmailVerificationUsecase>(
    () => EmailVerificationUsecase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerCachedFactory<CurrentUserUsecase>(
    () => CurrentUserUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerCachedFactory<SignOutUsecase>(
    () => SignOutUsecase(authRepository: getIt<AuthRepository>()),
  );
  // Auth Bloc
  getIt.registerLazySingleton(
    () => AuthBloc(
      appUserCubit: getIt<AppUserCubit>(),
      signUpUsecase: getIt<SignupUsecase>(),
      signInUsecase: getIt<SigninUsecase>(),
      signInWithGoogleUsecase: getIt<SigninWithGoogleUsecase>(),
      signOutUseCase: getIt<SignOutUsecase>(),
      emailVerificationUsecase: getIt<EmailVerificationUsecase>(),
      forgotPasswordUsecase: getIt<ForgotPasswordUsecase>(),
      resetPasswordVerificationUsecase:
          getIt<ResetPasswordVerificationUsecase>(),
      resetPasswordUsecase: getIt<ResetPasswordUsecase>(),
      resetPasswordWithIdUsecase: getIt<ResetPasswordWithIdUsecase>(),
      currentUser: getIt<CurrentUserUsecase>(),
    ),
  );
}

// All Profile Objects
void _initProfile() {
  // initialize profile remote data source
  getIt.registerCachedFactory<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  // initialize profile repository with auth data sources
  getIt.registerCachedFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(
      secureStorageService: getIt<SecureStorageService>(),
      profileRemoteDataSource: getIt<ProfileRemoteDataSource>(),
    ),
  );

  //Profile Bloc use cases
  getIt.registerCachedFactory<GetProfileUsecase>(
    () => GetProfileUsecase(profileRepository: getIt<ProfileRepository>()),
  );

  getIt.registerCachedFactory<UpdateProfileUsecase>(
    () => UpdateProfileUsecase(profileRepository: getIt<ProfileRepository>()),
  );

  getIt.registerCachedFactory<DeleteProfileUsecase>(
    () => DeleteProfileUsecase(profileRepository: getIt<ProfileRepository>()),
  );

  getIt.registerCachedFactory<UpdatePlayerIdUseCase>(
    () => UpdatePlayerIdUseCase(profileRepository: getIt<ProfileRepository>()),
  );

  // Profile Bloc
  getIt.registerLazySingleton(
    () => ProfileBloc(
      getProfileUsecase: getIt<GetProfileUsecase>(),
      updateProfileUsecase: getIt<UpdateProfileUsecase>(),
      deleteProfileUsecase: getIt<DeleteProfileUsecase>(),
      updatePlayerIdUseCase: getIt<UpdatePlayerIdUseCase>(),
      appUserCubit: getIt<AppUserCubit>(),
    ),
  );
}

void _initBooking() {
  // map
  _initMap();
  // booking
  _initBookingStage();
  _initBookingDetails();
}

void _initMap() {
  // initialize map remote data source
  getIt.registerCachedFactory<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(),
  );

  // initialize map repository with auth data sources
  getIt.registerCachedFactory<MapRepository>(
    () => MapRepositoryImpl(mapRemoteDataSource: getIt<MapRemoteDataSource>()),
  );

  //Map Bloc use cases
  getIt.registerCachedFactory<GetAddressUsecase>(
    () => GetAddressUsecase(mapRepository: getIt<MapRepository>()),
  );

  getIt.registerCachedFactory<GetCoordinatesFromPlaceIdUsecase>(
    () =>
        GetCoordinatesFromPlaceIdUsecase(mapRepository: getIt<MapRepository>()),
  );

  getIt.registerCachedFactory<GetPlaceFromNameUsecase>(
    () => GetPlaceFromNameUsecase(mapRepository: getIt<MapRepository>()),
  );

  getIt.registerCachedFactory<GetDirectionsUsecase>(
    () => GetDirectionsUsecase(mapRepository: getIt<MapRepository>()),
  );

  // GeoCoder
  getIt.registerCachedFactory<LocatitonGeocoder>(
    () => LocatitonGeocoder(Constants.mapKey),
  );

  // Map Bloc
  getIt.registerLazySingleton(
    () => MapBloc(
      geocoder: getIt<LocatitonGeocoder>(),
      getAddressUsecase: getIt<GetAddressUsecase>(),
      getCoordinatesFromPlaceIdUsecase:
          getIt<GetCoordinatesFromPlaceIdUsecase>(),
      getPlaceFromNameUsecase: getIt<GetPlaceFromNameUsecase>(),
      getDirectionsUsecase: getIt<GetDirectionsUsecase>(),
    ),
  );
}

void _initBookingStage() {
  // Booking
  getIt.registerLazySingleton(() => BookingStageCubit());
}

void _initBookingDetails() {
  // initialize booking remote data source
  getIt.registerCachedFactory<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(),
  );

  // initialize booking repository with auth data sources
  getIt.registerCachedFactory<BookingRepository>(
    () => BookingRepositoryImpl(
      secureStorageService: getIt<SecureStorageService>(),
      bookingRemoteDataSource: getIt<BookingRemoteDataSource>(),
    ),
  );

  //Booking Bloc use cases
  getIt.registerCachedFactory<CreateBookingUsecase>(
    () => CreateBookingUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<GetBookingByIdUsecase>(
    () => GetBookingByIdUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<AssignVehicleUsecase>(
    () => AssignVehicleUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<CancelBookingUsecase>(
    () => CancelBookingUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<EmergencyStopUsecase>(
    () => EmergencyStopUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<CompleteBookingUsecase>(
    () => CompleteBookingUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  // Booking Bloc
  getIt.registerLazySingleton(
    () => BookingBloc(
      createBookingUsecase: getIt<CreateBookingUsecase>(),
      getBookingByIdUsecase: getIt<GetBookingByIdUsecase>(),
      assignVehicleUsecase: getIt<AssignVehicleUsecase>(),
      verifyOtpUsecase: getIt<VerifyOtpUsecase>(),
      cancelBookingUsecase: getIt<CancelBookingUsecase>(),
      emergencyStopUsecase: getIt<EmergencyStopUsecase>(),
      completeBookingUsecase: getIt<CompleteBookingUsecase>(),
    ),
  );
}

void _initCampus() {
  // initialize campus remote data source
  getIt.registerCachedFactory<CampusRemoteDataSource>(
    () => CampusRemoteDataSourceImpl(),
  );

  // initialize campus repository with auth data sources
  getIt.registerCachedFactory<CampusRepository>(
    () => CampusRepositoryImpl(
      campusRemoteDataSource: getIt<CampusRemoteDataSource>(),
    ),
  );

  //Campus Bloc use cases
  getIt.registerCachedFactory<GetCampusesUsecase>(
    () => GetCampusesUsecase(campusRepository: getIt<CampusRepository>()),
  );

  // Campus Bloc
  getIt.registerLazySingleton(
    () => CampusBloc(getAllCampuses: getIt<GetCampusesUsecase>()),
  );
}

void _initActivity() {
  //Activity Bloc use cases
  getIt.registerCachedFactory<GetPastBookingsUsecase>(
    () => GetPastBookingsUsecase(bookingRepository: getIt<BookingRepository>()),
  );

  getIt.registerCachedFactory<GetUpcomingBookingsUsecase>(
    () => GetUpcomingBookingsUsecase(
      bookingRepository: getIt<BookingRepository>(),
    ),
  );

  // Activity Bloc
  getIt.registerLazySingleton(
    () => ActivityBloc(
      getPastBookingsUsecase: getIt<GetPastBookingsUsecase>(),
      getUpcomingBookingsUsecase: getIt<GetUpcomingBookingsUsecase>(),
    ),
  );
}

void _initVehicle() {
  // initialize vehicle remote data source
  getIt.registerCachedFactory<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(),
  );

  // initialize vehicle repository with auth data sources
  getIt.registerCachedFactory<VehicleRepository>(
    () => VehicleRepositoryImpl(
      vehicleRemoteDataSource: getIt<VehicleRemoteDataSource>(),
      secureStorageService: getIt(),
    ),
  );

  //Vehicle Bloc use cases
  getIt.registerCachedFactory<GetVehicleByDriverIdUsecase>(
    () => GetVehicleByDriverIdUsecase(
      vehicleRepository: getIt<VehicleRepository>(),
    ),
  );

  // Vehicle Bloc
  getIt.registerLazySingleton(
    () =>
        VehicleBloc(getVehicleByDriverId: getIt<GetVehicleByDriverIdUsecase>()),
  );
}

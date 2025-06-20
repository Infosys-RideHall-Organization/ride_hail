import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/features/auth/domain/usecases/remote_auth_usecases/sign_out.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../../core/entities/auth/user.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/remote_auth_usecases/current_user.dart';
import '../../../domain/usecases/remote_auth_usecases/email_verification.dart';
import '../../../domain/usecases/remote_auth_usecases/forgot_password.dart';
import '../../../domain/usecases/remote_auth_usecases/reset_password.dart';
import '../../../domain/usecases/remote_auth_usecases/reset_password_verification.dart';
import '../../../domain/usecases/remote_auth_usecases/reset_password_with_id.dart';
import '../../../domain/usecases/remote_auth_usecases/signin.dart';
import '../../../domain/usecases/remote_auth_usecases/signin_with_google.dart';
import '../../../domain/usecases/remote_auth_usecases/signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final SignupUsecase _signUpUsecase;
  final SigninUsecase _signInUsecase;
  final SigninWithGoogleUsecase _signInWithGoogleUsecase;

  final EmailVerificationUsecase _emailVerificationUsecase;

  final ForgotPasswordUsecase _forgotPasswordUsecase;

  final ResetPasswordVerificationUsecase _resetPasswordVerificationUsecase;

  final ResetPasswordUsecase _resetPasswordUsecase;
  final ResetPasswordWithIdUsecase _resetPasswordWithIdUsecase;

  final CurrentUserUsecase _currentUser;
  final SignOutUsecase _signOutUsecase;

  AuthBloc({
    required AppUserCubit appUserCubit,
    required SignupUsecase signUpUsecase,
    required SigninUsecase signInUsecase,
    required SigninWithGoogleUsecase signInWithGoogleUsecase,
    required EmailVerificationUsecase emailVerificationUsecase,
    required ForgotPasswordUsecase forgotPasswordUsecase,
    required ResetPasswordVerificationUsecase resetPasswordVerificationUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required ResetPasswordWithIdUsecase resetPasswordWithIdUsecase,
    required CurrentUserUsecase currentUser,
    required SignOutUsecase signOutUseCase,
  }) : _appUserCubit = appUserCubit,
       _signUpUsecase = signUpUsecase,
       _signInUsecase = signInUsecase,
       _signInWithGoogleUsecase = signInWithGoogleUsecase,
       _emailVerificationUsecase = emailVerificationUsecase,
       _forgotPasswordUsecase = forgotPasswordUsecase,
       _resetPasswordVerificationUsecase = resetPasswordVerificationUsecase,
       _resetPasswordUsecase = resetPasswordUsecase,
       _resetPasswordWithIdUsecase = resetPasswordWithIdUsecase,
       _currentUser = currentUser,
       _signOutUsecase = signOutUseCase,
       super(AuthInitial()) {
    // Any Auth Event
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    // Sign up event
    on<AuthSignUp>((event, emit) async {
      final response = await _signUpUsecase(
        SignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      response.fold((failure) => emit(AuthFailure(message: failure.message)), (
        user,
      ) {
        //    _appUserCubit.updateUserStatus(user);
        emit(AuthSuccess(user: user));
      });
    });

    // Sign in event
    on<AuthSignIn>((event, emit) async {
      final response = await _signInUsecase(
        SignInParams(email: event.email, password: event.password),
      );

      response.fold((failure) => emit(AuthFailure(message: failure.message)), (
        user,
      ) {
        _appUserCubit.updateUserStatus(user);
        emit(AuthSuccess(user: user));
      });
    });

    // Sign in google event
    on<AuthGoogleSignIn>((event, emit) async {
      final response = await _signInWithGoogleUsecase(
        SigninWithGoogleParams(idToken: event.idToken),
      );

      response.fold((failure) => emit(AuthFailure(message: failure.message)), (
        user,
      ) {
        _appUserCubit.updateUserStatus(user);
        emit(AuthSuccess(user: user));
      });
    });

    on<AuthSignOut>((event, emit) async {
      final response = await _signOutUsecase(NoParams());

      response.fold((failure) => emit(AuthFailure(message: failure.message)), (
        isSignOut,
      ) {
        _appUserCubit.updateUserStatus(null);
        emit(AuthInitial());
      });
    });

    // Email Verification event
    on<AuthEmailVerification>((event, emit) async {
      final response = await _emailVerificationUsecase(
        EmailVerificationParams(verificationToken: event.verificationToken),
      );
      response.fold(
        (failure) =>
            emit(AuthEmailVerificationFailure(message: failure.message)),
        (user) => emit(AuthEmailVerificationSuccess(user: user)),
      );
    });

    // Forgot password event
    on<AuthForgotPassword>((event, emit) async {
      final response = await _forgotPasswordUsecase(
        ForgotPasswordParams(email: event.email),
      );
      response.fold(
        (failure) => emit(AuthForgotPasswordFailure(message: failure.message)),
        (message) => emit(AuthForgotPasswordSuccess(message: message)),
      );
    });

    // Reset password otp verification event
    on<AuthResetPasswordVerification>((event, emit) async {
      final response = await _resetPasswordVerificationUsecase(
        ResetPasswordVerificationParams(
          resetPasswordToken: event.resetPasswordToken,
        ),
      );
      response.fold(
        (failure) =>
            emit(AuthResetPasswordVerificationFailure(error: failure.message)),
        (message) =>
            emit(AuthResetPasswordVerificationSuccess(message: message)),
      );
    });

    // Reset password event
    on<AuthResetPassword>((event, emit) async {
      final response = await _resetPasswordUsecase(
        ResetPasswordParams(
          password: event.password,
          resetPasswordToken: event.resetPasswordToken,
        ),
      );

      response.fold(
        (failure) => emit(AuthResetPasswordFailure(error: failure.message)),
        (message) => emit(AuthResetPasswordSuccess(message: message)),
      );
    });

    // Reset password with id event
    on<AuthResetPasswordWithId>((event, emit) async {
      final response = await _resetPasswordWithIdUsecase(
        ResetPasswordWithIdParams(password: event.password),
      );

      response.fold(
        (failure) => emit(AuthResetPasswordFailure(error: failure.message)),
        (message) => emit(AuthResetPasswordSuccess(message: message)),
      );
    });

    //Check current user
    on<AuthIsUserSignedIn>((event, emit) async {
      final response = await _currentUser(NoParams());
      response.fold((Failure failure) {
        emit(AuthFailure(message: failure.message));
        _appUserCubit.updateUserStatus(null);
      }, (user) => _emitAuthSuccess(user, emit));
    });
  }

  // Helper function to update cubit and bloc auth status
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUserStatus(user);
    emit(AuthSuccess(user: user));
  }
}

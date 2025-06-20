part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

// States for Signin and Signup
final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
}

//States for email verification
final class AuthEmailVerificationSuccess extends AuthState {
  final User user;
  const AuthEmailVerificationSuccess({required this.user});
}

final class AuthEmailVerificationFailure extends AuthState {
  final String message;
  const AuthEmailVerificationFailure({required this.message});
}

// States for Forgot password
final class AuthForgotPasswordSuccess extends AuthState {
  final String message;
  const AuthForgotPasswordSuccess({required this.message});
}

final class AuthForgotPasswordFailure extends AuthState {
  final String message;
  const AuthForgotPasswordFailure({required this.message});
}

// States for reset password verification

final class AuthResetPasswordVerificationSuccess extends AuthState {
  final String message;

  const AuthResetPasswordVerificationSuccess({required this.message});
}

final class AuthResetPasswordVerificationFailure extends AuthState {
  final String error;

  const AuthResetPasswordVerificationFailure({required this.error});
}

// States for reset password
final class AuthResetPasswordSuccess extends AuthState {
  final String message;

  const AuthResetPasswordSuccess({required this.message});
}

final class AuthResetPasswordFailure extends AuthState {
  final String error;

  const AuthResetPasswordFailure({required this.error});
}

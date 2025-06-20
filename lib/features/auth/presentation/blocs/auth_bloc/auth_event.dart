part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  const AuthSignIn({required this.email, required this.password});
}

final class AuthGoogleSignIn extends AuthEvent {
  final String idToken;

  const AuthGoogleSignIn({required this.idToken});
}

final class AuthEmailVerification extends AuthEvent {
  final String verificationToken;

  const AuthEmailVerification({required this.verificationToken});
}

final class AuthForgotPassword extends AuthEvent {
  final String email;

  const AuthForgotPassword({required this.email});
}

final class AuthResetPasswordVerification extends AuthEvent {
  final String resetPasswordToken;

  const AuthResetPasswordVerification({required this.resetPasswordToken});
}

final class AuthResetPassword extends AuthEvent {
  final String resetPasswordToken;
  final String password;

  const AuthResetPassword({
    required this.resetPasswordToken,
    required this.password,
  });
}

final class AuthResetPasswordWithId extends AuthEvent {
  final String password;

  const AuthResetPasswordWithId({required this.password});
}

final class AuthIsUserSignedIn extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}

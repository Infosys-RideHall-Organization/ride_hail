import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/auth/user.dart';
import '../../../../core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithGoogle({required String idToken});

  Future<Either<Failure, User>> emailVerification({
    required String verificationToken,
  });

  Future<Either<Failure, String>> forgotPasswordWithEmail({
    required String email,
  });

  Future<Either<Failure, String>> resetPasswordVerification({
    required String resetPasswordToken,
  });

  Future<Either<Failure, String>> resetPassword({
    required String password,
    required String resetPasswordToken,
  });

  Future<Either<Failure, String>> resetPasswordWithId({
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, bool>> signOut();
}

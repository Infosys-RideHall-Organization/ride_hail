import 'package:fpdart/fpdart.dart';

import '../../../../../core/entities/auth/user.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class SigninUsecase implements Usecase<User, SignInParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await authRepository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }

  const SigninUsecase({required this.authRepository});
}

class SignInParams {
  String email;
  String password;

  SignInParams({required this.email, required this.password});
}

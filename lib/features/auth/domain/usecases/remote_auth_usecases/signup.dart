import 'package:fpdart/fpdart.dart';

import '../../../../../core/entities/auth/user.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class SignupUsecase implements Usecase<User, SignUpParams> {
  final AuthRepository authRepository;

  const SignupUsecase({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

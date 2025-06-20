import 'package:fpdart/fpdart.dart';

import '../../../../../core/entities/auth/user.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class SigninWithGoogleUsecase implements Usecase<User, SigninWithGoogleParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, User>> call(SigninWithGoogleParams params) async {
    return await authRepository.signInWithGoogle(idToken: params.idToken);
  }

  const SigninWithGoogleUsecase({required this.authRepository});
}

class SigninWithGoogleParams {
  String idToken;

  SigninWithGoogleParams({required this.idToken});
}

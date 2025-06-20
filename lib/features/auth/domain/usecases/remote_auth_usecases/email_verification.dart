import 'package:fpdart/fpdart.dart';

import '../../../../../core/entities/auth/user.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class EmailVerificationUsecase
    implements Usecase<User, EmailVerificationParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, User>> call(EmailVerificationParams params) async {
    return await authRepository.emailVerification(
      verificationToken: params.verificationToken,
    );
  }

  const EmailVerificationUsecase({required this.authRepository});
}

class EmailVerificationParams {
  final String verificationToken;
  EmailVerificationParams({required this.verificationToken});
}

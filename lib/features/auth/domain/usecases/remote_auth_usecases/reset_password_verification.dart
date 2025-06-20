import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordVerificationUsecase
    implements Usecase<String, ResetPasswordVerificationParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(
    ResetPasswordVerificationParams params,
  ) async {
    return await authRepository.resetPasswordVerification(
      resetPasswordToken: params.resetPasswordToken,
    );
  }

  const ResetPasswordVerificationUsecase({required this.authRepository});
}

class ResetPasswordVerificationParams {
  String resetPasswordToken;
  ResetPasswordVerificationParams({required this.resetPasswordToken});
}

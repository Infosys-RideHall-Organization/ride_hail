import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordUsecase implements Usecase<String, ResetPasswordParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) async {
    return await authRepository.resetPassword(
      password: params.password,
      resetPasswordToken: params.resetPasswordToken,
    );
  }

  const ResetPasswordUsecase({required this.authRepository});
}

class ResetPasswordParams {
  final String password;
  final String resetPasswordToken;

  const ResetPasswordParams({
    required this.password,
    required this.resetPasswordToken,
  });
}

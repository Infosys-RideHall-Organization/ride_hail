import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordWithIdUsecase
    implements Usecase<String, ResetPasswordWithIdParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(ResetPasswordWithIdParams params) async {
    return await authRepository.resetPasswordWithId(password: params.password);
  }

  const ResetPasswordWithIdUsecase({required this.authRepository});
}

class ResetPasswordWithIdParams {
  final String password;

  const ResetPasswordWithIdParams({required this.password});
}

import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class SignOutUsecase implements Usecase<bool, NoParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signOut();
  }

  const SignOutUsecase({required this.authRepository});
}

import 'package:fpdart/fpdart.dart';

import '../../../../../core/entities/auth/user.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../repositories/auth_repository.dart';

class CurrentUserUsecase implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }

  const CurrentUserUsecase({required this.authRepository});
}

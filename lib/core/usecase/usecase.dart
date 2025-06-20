import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

//if no params need to be passed
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];

  const NoParams();
}

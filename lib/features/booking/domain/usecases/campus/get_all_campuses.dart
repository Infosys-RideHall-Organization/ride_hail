import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/campus/campus.dart';
import '../../repositories/campus/campus_repository.dart';

class GetCampusesUsecase implements Usecase<List<Campus>, NoParams> {
  final CampusRepository campusRepository;

  const GetCampusesUsecase({required this.campusRepository});

  @override
  Future<Either<Failure, List<Campus>>> call(NoParams params) {
    return campusRepository.fetchCampuses();
  }
}

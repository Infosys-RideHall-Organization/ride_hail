import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/campus/campus.dart';

abstract interface class CampusRepository {
  Future<Either<Failure, List<Campus>>> fetchCampuses();
}

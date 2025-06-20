import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/campus/campus.dart';
import '../../../domain/repositories/campus/campus_repository.dart';
import '../../datasources/campus/campus_remote_datasource.dart';

class CampusRepositoryImpl implements CampusRepository {
  final CampusRemoteDataSource campusRemoteDataSource;

  CampusRepositoryImpl({required this.campusRemoteDataSource});

  @override
  Future<Either<Failure, List<Campus>>> fetchCampuses() async {
    try {
      final campuses = await campusRemoteDataSource.fetchCampuses();
      return right(campuses);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

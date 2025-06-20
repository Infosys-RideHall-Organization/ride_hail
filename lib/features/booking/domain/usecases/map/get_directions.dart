import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/map/directions.dart';
import '../../repositories/map/map_repository.dart';

class GetDirectionsUsecase implements Usecase<Directions, GetDirectionsParams> {
  final MapRepository mapRepository;

  const GetDirectionsUsecase({required this.mapRepository});

  @override
  Future<Either<Failure, Directions>> call(GetDirectionsParams params) async {
    return await mapRepository.getDirections(
      originLat: params.originLat,
      originLng: params.originLng,
      destinationLat: params.destinationLat,
      destinationLng: params.destinationLng,
    );
  }
}

class GetDirectionsParams {
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;

  GetDirectionsParams({
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
  });
}

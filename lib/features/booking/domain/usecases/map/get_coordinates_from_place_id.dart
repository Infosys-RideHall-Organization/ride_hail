import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/map/place_details.dart';
import '../../repositories/map/map_repository.dart';

class GetCoordinatesFromPlaceIdUsecase
    implements Usecase<PlaceDetail, PlaceIdParams> {
  final MapRepository mapRepository;

  const GetCoordinatesFromPlaceIdUsecase({required this.mapRepository});

  @override
  Future<Either<Failure, PlaceDetail>> call(PlaceIdParams params) async {
    return await mapRepository.getCoordinatesFromPlaceId(
      placeId: params.placeId,
    );
  }
}

class PlaceIdParams {
  final String placeId;

  PlaceIdParams({required this.placeId});
}

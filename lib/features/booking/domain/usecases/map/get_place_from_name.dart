import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/map/get_places.dart';
import '../../repositories/map/map_repository.dart';

class GetPlaceFromNameUsecase implements Usecase<GetPlace, PlaceNameParams> {
  final MapRepository mapRepository;

  const GetPlaceFromNameUsecase({required this.mapRepository});

  @override
  Future<Either<Failure, GetPlace>> call(PlaceNameParams params) async {
    return await mapRepository.placeFromNames(placeName: params.placeName);
  }
}

class PlaceNameParams {
  final String placeName;

  PlaceNameParams({required this.placeName});
}

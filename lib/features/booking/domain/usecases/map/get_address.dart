import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/map/geocoding.dart';
import '../../repositories/map/map_repository.dart';

class GetAddressUsecase implements Usecase<Geocode, GetAddressParams> {
  final MapRepository mapRepository;

  const GetAddressUsecase({required this.mapRepository});

  @override
  Future<Either<Failure, Geocode>> call(GetAddressParams params) async {
    return await mapRepository.getAddressUsingLatLng(
      lat: params.lat,
      long: params.long,
    );
  }
}

class GetAddressParams {
  final double lat;
  final double long;

  GetAddressParams({required this.lat, required this.long});
}

import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/map/directions.dart';
import '../../entities/map/geocoding.dart';
import '../../entities/map/get_places.dart';
import '../../entities/map/place_details.dart';

abstract interface class MapRepository {
  Future<Either<Failure, Geocode>> getAddressUsingLatLng({
    required double lat,
    required double long,
  });
  Future<Either<Failure, GetPlace>> placeFromNames({required String placeName});
  Future<Either<Failure, PlaceDetail>> getCoordinatesFromPlaceId({
    required String placeId,
  });

  Future<Either<Failure, Directions>> getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  });
}

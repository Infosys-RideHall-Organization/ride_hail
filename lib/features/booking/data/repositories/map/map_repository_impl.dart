import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/map/directions.dart';
import '../../../domain/entities/map/geocoding.dart';
import '../../../domain/entities/map/get_places.dart';
import '../../../domain/entities/map/place_details.dart';
import '../../../domain/repositories/map/map_repository.dart';
import '../../datasources/map/map_remote_data_source.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource mapRemoteDataSource;

  MapRepositoryImpl({required this.mapRemoteDataSource});

  @override
  Future<Either<Failure, Geocode>> getAddressUsingLatLng({
    required double lat,
    required double long,
  }) async {
    try {
      final geocode = await mapRemoteDataSource.getAddressUsingLatLng(
        lat: lat,
        long: long,
      );
      return right(geocode);
    } on ServerException catch (e) {
      debugPrint('getAddressUsingLatLng Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, GetPlace>> placeFromNames({
    required String placeName,
  }) async {
    try {
      final place = await mapRemoteDataSource.placeFromNames(
        placeName: placeName,
      );
      return right(place);
    } on ServerException catch (e) {
      debugPrint('placeFromNames Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, PlaceDetail>> getCoordinatesFromPlaceId({
    required String placeId,
  }) async {
    try {
      final placeDetail = await mapRemoteDataSource.getCoordinatesFromPlaceId(
        placeId: placeId,
      );
      return right(placeDetail);
    } on ServerException catch (e) {
      debugPrint('getCoordinatesFromPlaceId Error: ${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Directions>> getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    try {
      final directions = await mapRemoteDataSource.getDirections(
        originLat: originLat,
        originLng: originLng,
        destinationLat: destinationLat,
        destinationLng: destinationLng,
      );
      return right(directions);
    } on ServerException catch (e) {
      debugPrint('getDirections Error: ${e.message}');
      return left(Failure(e.message));
    }
  }
}

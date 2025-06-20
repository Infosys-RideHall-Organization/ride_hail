import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_hail/core/constants/constants.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/map/directions_model.dart';
import '../../models/map/geocoding_model.dart';
import '../../models/map/get_places_model.dart';
import '../../models/map/place_details_model.dart';

abstract interface class MapRemoteDataSource {
  Future<GeocodeModel> getAddressUsingLatLng({
    required double lat,
    required double long,
  });

  Future<GetPlaceModel> placeFromNames({required String placeName});

  Future<PlaceDetailModel> getCoordinatesFromPlaceId({required String placeId});

  Future<DirectionsModel> getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  });
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  @override
  Future<GeocodeModel> getAddressUsingLatLng({
    required double lat,
    required double long,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${Constants.mapKey}',
        ),
      );

      //    debugPrint(response.body);

      if (response.statusCode == 200) {
        return GeocodeModel.fromJson(response.body);
      } else {
        throw ServerException(
          message:
              jsonDecode(response.body)['error_message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<GetPlaceModel> placeFromNames({required String placeName}) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${Constants.mapKey}',
        ),
      );

      //    debugPrint(response.body);

      if (response.statusCode == 200) {
        return GetPlaceModel.fromJson(response.body);
      } else {
        throw ServerException(
          message:
              jsonDecode(response.body)['error_message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PlaceDetailModel> getCoordinatesFromPlaceId({
    required String placeId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.mapKey}',
        ),
      );

      //  debugPrint(response.body);

      if (response.statusCode == 200) {
        return PlaceDetailModel.fromJson(response.body);
      } else {
        throw ServerException(
          message:
              jsonDecode(response.body)['error_message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DirectionsModel> getDirections({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$originLat,$originLng'
          '&destination=$destinationLat,$destinationLng'
          '&key=${Constants.mapKey}',
        ),
      );

      if (response.statusCode == 200) {
        return DirectionsModel.fromJson(response.body);
      } else {
        throw ServerException(
          message:
              jsonDecode(response.body)['error_message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      debugPrint('Directions API Error: $e');
      throw ServerException(message: e.toString());
    }
  }
}

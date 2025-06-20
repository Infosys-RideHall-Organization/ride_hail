import 'dart:convert';

import '../../../domain/entities/map/geocoding.dart';

class GeocodeModel extends Geocode {
  const GeocodeModel({
    super.plusCode,
    required super.results,
    required super.status,
  });

  factory GeocodeModel.fromJson(String json) {
    return GeocodeModel.fromMap(jsonDecode(json));
  }

  factory GeocodeModel.fromMap(Map<String, dynamic> map) {
    return GeocodeModel(
      plusCode:
          map['plus_code'] != null
              ? PlusCodeModel.fromMap(map['plus_code'])
              : null,
      results:
          (map['results'] as List)
              .map((e) => GeocodeResultModel.fromMap(e))
              .toList(),
      status: map['status'],
    );
  }
}

class PlusCodeModel extends PlusCode {
  const PlusCodeModel({required super.compoundCode, required super.globalCode});

  factory PlusCodeModel.fromMap(Map<String, dynamic> map) {
    return PlusCodeModel(
      compoundCode: map['compound_code'],
      globalCode: map['global_code'],
    );
  }
}

class GeocodeResultModel extends GeocodeResult {
  const GeocodeResultModel({
    required super.addressComponents,
    required super.formattedAddress,
    required super.geometry,
    required super.placeId,
    required super.types,
    super.plusCode,
  });

  factory GeocodeResultModel.fromMap(Map<String, dynamic> map) {
    return GeocodeResultModel(
      addressComponents:
          (map['address_components'] as List)
              .map((e) => AddressComponentModel.fromMap(e))
              .toList(),
      formattedAddress: map['formatted_address'],
      geometry: GeometryModel.fromMap(map['geometry']),
      placeId: map['place_id'],
      types: List<String>.from(map['types']),
      plusCode:
          map['plus_code'] != null
              ? PlusCodeModel.fromMap(map['plus_code'])
              : null,
    );
  }
}

class AddressComponentModel extends AddressComponent {
  const AddressComponentModel({
    required super.longName,
    required super.shortName,
    required super.types,
  });

  factory AddressComponentModel.fromMap(Map<String, dynamic> map) {
    return AddressComponentModel(
      longName: map['long_name'],
      shortName: map['short_name'],
      types: List<String>.from(map['types']),
    );
  }
}

class GeometryModel extends Geometry {
  const GeometryModel({
    required super.location,
    required super.locationType,
    required super.viewport,
    super.bounds,
  });

  factory GeometryModel.fromMap(Map<String, dynamic> map) {
    return GeometryModel(
      location: LocationModel.fromMap(map['location']),
      locationType: map['location_type'],
      viewport: BoundsModel.fromMap(map['viewport']),
      bounds: map['bounds'] != null ? BoundsModel.fromMap(map['bounds']) : null,
    );
  }
}

class LocationModel extends Location {
  const LocationModel({required super.lat, required super.lng});

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
    );
  }
}

class BoundsModel extends Bounds {
  const BoundsModel({required super.northeast, required super.southwest});

  factory BoundsModel.fromMap(Map<String, dynamic> map) {
    return BoundsModel(
      northeast: LocationModel.fromMap(map['northeast']),
      southwest: LocationModel.fromMap(map['southwest']),
    );
  }
}

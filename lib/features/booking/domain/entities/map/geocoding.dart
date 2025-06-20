import 'package:equatable/equatable.dart';

class Geocode extends Equatable {
  final PlusCode? plusCode;
  final List<GeocodeResult> results;
  final String status;

  const Geocode({this.plusCode, required this.results, required this.status});

  @override
  List<Object?> get props => [plusCode, results, status];

  @override
  String toString() {
    return 'Geocode{plusCode: $plusCode, results: $results, status: $status}';
  }
}

class PlusCode extends Equatable {
  final String compoundCode;
  final String globalCode;

  const PlusCode({required this.compoundCode, required this.globalCode});

  @override
  List<Object> get props => [compoundCode, globalCode];

  @override
  String toString() {
    return 'PlusCode{compoundCode: $compoundCode, globalCode: $globalCode}';
  }
}

class GeocodeResult extends Equatable {
  final List<AddressComponent> addressComponents;
  final String formattedAddress;
  final Geometry geometry;
  final String placeId;
  final List<String> types;
  final PlusCode? plusCode;

  const GeocodeResult({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
    this.plusCode,
  });

  @override
  List<Object?> get props => [
    addressComponents,
    formattedAddress,
    geometry,
    placeId,
    types,
    plusCode,
  ];

  @override
  String toString() {
    return 'GeocodeResult{addressComponents: $addressComponents, formattedAddress: $formattedAddress, geometry: $geometry, placeId: $placeId, types: $types, plusCode: $plusCode}';
  }
}

class AddressComponent extends Equatable {
  final String longName;
  final String shortName;
  final List<String> types;

  const AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  @override
  List<Object> get props => [longName, shortName, types];

  @override
  String toString() {
    return 'AddressComponent{longName: $longName, shortName: $shortName, types: $types}';
  }
}

class Geometry extends Equatable {
  final Location location;
  final String locationType;
  final Bounds viewport;
  final Bounds? bounds;

  const Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
    this.bounds,
  });

  @override
  List<Object?> get props => [location, locationType, viewport, bounds];

  @override
  String toString() {
    return 'Geometry{location: $location, locationType: $locationType, viewport: $viewport, bounds: $bounds}';
  }
}

class Location extends Equatable {
  final double lat;
  final double lng;

  const Location({required this.lat, required this.lng});

  @override
  List<Object> get props => [lat, lng];

  @override
  String toString() {
    return 'Location{lat: $lat, lng: $lng}';
  }
}

class Bounds extends Equatable {
  final Location northeast;
  final Location southwest;

  const Bounds({required this.northeast, required this.southwest});

  @override
  List<Object> get props => [northeast, southwest];
}

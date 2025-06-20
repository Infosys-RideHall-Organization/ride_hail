import 'package:equatable/equatable.dart';

class Directions extends Equatable {
  final List<GeocodedWaypoint> geocodedWaypoints;
  final List<Route> routes;

  const Directions({required this.geocodedWaypoints, required this.routes});

  factory Directions.initial() =>
      const Directions(geocodedWaypoints: [], routes: []);

  factory Directions.empty() => Directions.initial();

  @override
  List<Object?> get props => [geocodedWaypoints, routes];
}

class GeocodedWaypoint extends Equatable {
  final String geocoderStatus;
  final String placeId;
  final List<String> types;

  const GeocodedWaypoint({
    required this.geocoderStatus,
    required this.placeId,
    required this.types,
  });

  factory GeocodedWaypoint.empty() =>
      const GeocodedWaypoint(geocoderStatus: '', placeId: '', types: []);

  @override
  List<Object?> get props => [geocoderStatus, placeId, types];
}

class Route extends Equatable {
  final Bounds bounds;
  final String overviewPolyline;
  final List<Leg> legs;

  const Route({
    required this.bounds,
    required this.overviewPolyline,
    required this.legs,
  });

  factory Route.empty() =>
      Route(bounds: Bounds.empty(), overviewPolyline: '', legs: []);

  @override
  List<Object?> get props => [bounds, overviewPolyline, legs];
}

class Bounds extends Equatable {
  final LatLngEntity northeast;
  final LatLngEntity southwest;

  const Bounds({required this.northeast, required this.southwest});

  factory Bounds.empty() =>
      Bounds(northeast: LatLngEntity.empty(), southwest: LatLngEntity.empty());

  @override
  List<Object?> get props => [northeast, southwest];
}

class Leg extends Equatable {
  final TextValue distance;
  final TextValue duration;
  final String startAddress;
  final String endAddress;
  final LatLngEntity startLocation;
  final LatLngEntity endLocation;
  final List<Step> steps;

  const Leg({
    required this.distance,
    required this.duration,
    required this.startAddress,
    required this.endAddress,
    required this.startLocation,
    required this.endLocation,
    required this.steps,
  });

  factory Leg.empty() => Leg(
    distance: TextValue.empty(),
    duration: TextValue.empty(),
    startAddress: '',
    endAddress: '',
    startLocation: LatLngEntity.empty(),
    endLocation: LatLngEntity.empty(),
    steps: [],
  );

  @override
  List<Object?> get props => [
    distance,
    duration,
    startAddress,
    endAddress,
    startLocation,
    endLocation,
    steps,
  ];
}

class Step extends Equatable {
  final TextValue distance;
  final TextValue duration;
  final LatLngEntity startLocation;
  final LatLngEntity endLocation;
  final String htmlInstructions;
  final String polyline;
  final String travelMode;
  final String? maneuver;

  const Step({
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.htmlInstructions,
    required this.polyline,
    required this.travelMode,
    this.maneuver,
  });

  factory Step.empty() => Step(
    distance: TextValue.empty(),
    duration: TextValue.empty(),
    startLocation: LatLngEntity.empty(),
    endLocation: LatLngEntity.empty(),
    htmlInstructions: '',
    polyline: '',
    travelMode: '',
    maneuver: null,
  );

  @override
  List<Object?> get props => [
    distance,
    duration,
    startLocation,
    endLocation,
    htmlInstructions,
    polyline,
    travelMode,
    maneuver,
  ];
}

class LatLngEntity extends Equatable {
  final double lat;
  final double lng;

  const LatLngEntity({required this.lat, required this.lng});

  factory LatLngEntity.empty() => const LatLngEntity(lat: 0.0, lng: 0.0);

  @override
  List<Object?> get props => [lat, lng];
}

class TextValue extends Equatable {
  final String text;
  final int value;

  const TextValue({required this.text, required this.value});

  factory TextValue.empty() => const TextValue(text: '', value: 0);

  @override
  List<Object?> get props => [text, value];
}

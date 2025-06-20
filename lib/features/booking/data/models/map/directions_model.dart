import 'dart:convert';

import '../../../../booking/domain/entities/map/directions.dart';

class DirectionsModel extends Directions {
  const DirectionsModel({
    required super.geocodedWaypoints,
    required super.routes,
  });

  factory DirectionsModel.fromJson(String json) {
    return DirectionsModel.fromMap(jsonDecode(json));
  }

  factory DirectionsModel.fromMap(Map<String, dynamic> map) {
    return DirectionsModel(
      geocodedWaypoints:
          (map['geocoded_waypoints'] as List<dynamic>? ?? [])
              .map(
                (e) => GeocodedWaypointModel.fromMap(e as Map<String, dynamic>),
              )
              .toList(),
      routes:
          (map['routes'] as List<dynamic>? ?? [])
              .map((e) => RouteModel.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class GeocodedWaypointModel extends GeocodedWaypoint {
  const GeocodedWaypointModel({
    required super.geocoderStatus,
    required super.placeId,
    required super.types,
  });

  factory GeocodedWaypointModel.fromMap(Map<String, dynamic> map) {
    return GeocodedWaypointModel(
      geocoderStatus: map['geocoder_status'] ?? '',
      placeId: map['place_id'] ?? '',
      types: List<String>.from(map['types'] ?? []),
    );
  }
}

class RouteModel extends Route {
  const RouteModel({
    required super.bounds,
    required super.overviewPolyline,
    required super.legs,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      bounds: BoundsModel.fromMap(map['bounds'] ?? {}),
      overviewPolyline: (map['overview_polyline']?['points'] as String?) ?? '',
      legs:
          (map['legs'] as List<dynamic>? ?? [])
              .map((e) => LegModel.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class BoundsModel extends Bounds {
  const BoundsModel({required super.northeast, required super.southwest});

  factory BoundsModel.fromMap(Map<String, dynamic> map) {
    return BoundsModel(
      northeast: LatLngModel.fromMap(map['northeast'] ?? <String, dynamic>{}),
      southwest: LatLngModel.fromMap(map['southwest'] ?? <String, dynamic>{}),
    );
  }
}

class LegModel extends Leg {
  const LegModel({
    required super.distance,
    required super.duration,
    required super.startAddress,
    required super.endAddress,
    required super.startLocation,
    required super.endLocation,
    required super.steps,
  });

  factory LegModel.fromMap(Map<String, dynamic> map) {
    return LegModel(
      distance: TextValueModel.fromMap(map['distance'] ?? {}),
      duration: TextValueModel.fromMap(map['duration'] ?? {}),
      startAddress: map['start_address'] ?? '',
      endAddress: map['end_address'] ?? '',
      startLocation: LatLngModel.fromMap(map['start_location'] ?? {}),
      endLocation: LatLngModel.fromMap(map['end_location'] ?? {}),
      steps:
          (map['steps'] as List<dynamic>? ?? [])
              .map((e) => StepModel.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class StepModel extends Step {
  const StepModel({
    required super.distance,
    required super.duration,
    required super.startLocation,
    required super.endLocation,
    required super.htmlInstructions,
    required super.polyline,
    required super.travelMode,
    super.maneuver,
  });

  factory StepModel.fromMap(Map<String, dynamic> map) {
    return StepModel(
      distance: TextValueModel.fromMap(map['distance'] ?? {}),
      duration: TextValueModel.fromMap(map['duration'] ?? {}),
      startLocation: LatLngModel.fromMap(map['start_location'] ?? {}),
      endLocation: LatLngModel.fromMap(map['end_location'] ?? {}),
      htmlInstructions: map['html_instructions'] ?? '',
      polyline: (map['polyline']?['points'] as String?) ?? '',
      travelMode: map['travel_mode'] ?? '',
      maneuver: map['maneuver'],
    );
  }
}

class LatLngModel extends LatLngEntity {
  const LatLngModel({required super.lat, required super.lng});

  factory LatLngModel.fromMap(Map<String, dynamic> map) {
    return LatLngModel(
      lat: (map['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TextValueModel extends TextValue {
  const TextValueModel({required super.text, required super.value});

  factory TextValueModel.fromMap(Map<String, dynamic> map) {
    return TextValueModel(
      text: map['text'] ?? '',
      value: (map['value'] as int?) ?? 0,
    );
  }
}

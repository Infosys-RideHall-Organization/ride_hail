part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserLocation extends MapEvent {}

class SearchPlaces extends MapEvent {
  final String query;

  SearchPlaces(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectPlaceFromSearch extends MapEvent {
  final String placeId;

  SelectPlaceFromSearch(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class SelectFromMap extends MapEvent {
  final LatLng location;

  SelectFromMap(this.location);

  @override
  List<Object?> get props => [location];
}

class UpdateOrigin extends MapEvent {
  final LatLng origin;

  UpdateOrigin(this.origin);

  @override
  List<Object?> get props => [origin];
}

class UpdateDestination extends MapEvent {
  final LatLng destination;

  UpdateDestination(this.destination);

  @override
  List<Object?> get props => [destination];
}

class UpdateOriginFormattedAddress extends MapEvent {
  final LatLng origin;

  UpdateOriginFormattedAddress(this.origin);

  @override
  List<Object?> get props => [origin];
}

class UpdateDestinationFormattedAddress extends MapEvent {
  final LatLng destination;

  UpdateDestinationFormattedAddress(this.destination);

  @override
  List<Object?> get props => [destination];
}

class UpdatePolylines extends MapEvent {
  final List<LatLng> polylineCoordinates;
  final Set<Polyline> polylines;

  UpdatePolylines({required this.polylineCoordinates, required this.polylines});

  @override
  List<Object?> get props => [polylineCoordinates, polylines];
}

class UpdateMarkers extends MapEvent {
  final Set<Marker> markers;

  UpdateMarkers(this.markers);

  @override
  List<Object?> get props => [markers];
}

class ClearSearchResults extends MapEvent {
  @override
  List<Object?> get props => [];
}

class ClearPolylines extends MapEvent {
  @override
  List<Object?> get props => [];
}

class ClearMapRoute extends MapEvent {
  @override
  List<Object?> get props => [];
}

class SetLoading extends MapEvent {
  final bool loading;

  SetLoading(this.loading);

  @override
  List<Object?> get props => [loading];
}

class FetchDirections extends MapEvent {
  final LatLng origin;
  final LatLng destination;

  FetchDirections({required this.origin, required this.destination});

  @override
  List<Object?> get props => [origin, destination];
}

class ResetMap extends MapEvent {}

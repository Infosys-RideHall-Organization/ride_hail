part of 'map_bloc.dart';

class MapState extends Equatable {
  final LatLng? origin;
  final String originFormattedAddress;
  final LatLng? destination;
  final String destinationFormattedAddress;
  final List<LatLng> polylineCoordinates;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final GetPlace searchResults;
  final String searchQuery;
  final bool loading;
  final String? errorMessage;
  final PlaceDetail? placeDetail;
  final bool directionsLoading; // Flag to indicate loading for directions
  final Directions? directions;

  const MapState({
    this.origin,
    this.destination,
    this.originFormattedAddress = '',
    this.destinationFormattedAddress = '',
    this.polylineCoordinates = const [],
    this.markers = const {},
    this.polylines = const {},
    this.searchResults = const GetPlace(predictions: [], status: ''),
    this.searchQuery = '',
    this.loading = false,
    this.errorMessage,
    this.placeDetail,
    this.directionsLoading = false,
    this.directions,
  });

  MapState copyWith({
    LatLng? origin,
    LatLng? destination,
    String? originFormattedAddress,
    String? destinationFormattedAddress,
    List<LatLng>? polylineCoordinates,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    GetPlace? searchResults,
    String? searchQuery,
    bool? loading,
    String? errorMessage,
    PlaceDetail? placeDetail,
    bool? directionsLoading,
    Directions? directions,
  }) {
    return MapState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      originFormattedAddress:
          originFormattedAddress ?? this.originFormattedAddress,
      destinationFormattedAddress:
          destinationFormattedAddress ?? this.destinationFormattedAddress,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      loading: loading ?? this.loading,
      placeDetail: placeDetail ?? this.placeDetail,
      directionsLoading: directionsLoading ?? this.directionsLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      directions: directions ?? this.directions,
    );
  }

  @override
  List<Object?> get props => [
    origin,
    destination,
    polylineCoordinates,
    markers,
    polylines,
    searchResults,
    searchQuery,
    loading,
    errorMessage,
    placeDetail,
    originFormattedAddress,
    destinationFormattedAddress,
    directionsLoading,
    directions,
  ];
}

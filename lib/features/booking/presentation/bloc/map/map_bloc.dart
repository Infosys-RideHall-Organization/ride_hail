import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:ride_hail/features/booking/domain/entities/map/directions.dart';
import 'package:ride_hail/features/booking/domain/entities/map/place_details.dart';
import 'package:ride_hail/features/booking/domain/usecases/map/get_directions.dart';

import '../../../domain/entities/map/get_places.dart';
import '../../../domain/usecases/map/get_address.dart';
import '../../../domain/usecases/map/get_coordinates_from_place_id.dart';
import '../../../domain/usecases/map/get_place_from_name.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetPlaceFromNameUsecase _getPlaceFromNameUsecase;
  final GetCoordinatesFromPlaceIdUsecase _getCoordinatesFromPlaceIdUsecase;

  final GetDirectionsUsecase _getDirectionsUsecase;

  final LocatitonGeocoder geocoder;
  MapBloc({
    required this.geocoder,
    required GetAddressUsecase getAddressUsecase,
    required GetPlaceFromNameUsecase getPlaceFromNameUsecase,
    required GetCoordinatesFromPlaceIdUsecase getCoordinatesFromPlaceIdUsecase,
    required GetDirectionsUsecase getDirectionsUsecase,
  }) : _getPlaceFromNameUsecase = getPlaceFromNameUsecase,
       _getCoordinatesFromPlaceIdUsecase = getCoordinatesFromPlaceIdUsecase,
       _getDirectionsUsecase = getDirectionsUsecase,
       super(const MapState()) {
    // calls
    on<LoadUserLocation>(_onLoadUserLocation);
    on<SearchPlaces>(_onSearchPlaces);
    on<SelectPlaceFromSearch>(_onSelectPlaceFromSearch);
    // position
    on<SelectFromMap>(_onSelectFromMap);
    on<UpdateOrigin>(_onUpdateOrigin);
    on<UpdateDestination>(_onUpdateDestination);
    on<UpdateOriginFormattedAddress>(_onUpdateOriginFormattedAddress);
    on<UpdateDestinationFormattedAddress>(_onUpdateDestinationFormattedAddress);
    on<UpdatePolylines>(_onUpdatePolylines);
    on<UpdateMarkers>(_onUpdateMarkers);
    on<ClearSearchResults>(_onClearSearchResults);
    on<ClearPolylines>(_onClearPolylines);
    on<ClearMapRoute>(_onClearMapRoute);
    on<FetchDirections>(_onFetchDirections);
    on<ResetMap>(_onResetMap);
  }

  Future<void> _onLoadUserLocation(
    LoadUserLocation event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      Position userPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
      emit(
        state.copyWith(
          origin: LatLng(userPosition.latitude, userPosition.longitude),
          loading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to load location: ${e.toString()}',
          loading: false,
        ),
      );
    }
  }

  Future<void> _onSearchPlaces(
    SearchPlaces event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(loading: true, searchQuery: event.query));
    final result = await _getPlaceFromNameUsecase(
      PlaceNameParams(placeName: event.query),
    );
    result.fold((failure) {
      debugPrint('Search places failure: ${failure.toString()}');
      emit(
        state.copyWith(loading: false, errorMessage: 'Failed to search places'),
      );
    }, (places) => emit(state.copyWith(searchResults: places, loading: false)));
  }

  Future<void> _onSelectPlaceFromSearch(
    SelectPlaceFromSearch event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final details = await _getCoordinatesFromPlaceIdUsecase(
      PlaceIdParams(placeId: event.placeId),
    );
    details.fold(
      (failure) {
        debugPrint('Place details failure: ${failure.toString()}');
        emit(
          state.copyWith(
            loading: false,
            errorMessage: 'Failed to get place details',
          ),
        );
      },
      (placeDetail) =>
          emit(state.copyWith(placeDetail: placeDetail, loading: false)),
    );
  }

  void _onSelectFromMap(SelectFromMap event, Emitter<MapState> emit) {
    emit(state.copyWith(destination: event.location));
  }

  void _onUpdateOrigin(UpdateOrigin event, Emitter<MapState> emit) {
    emit(state.copyWith(origin: event.origin));
  }

  void _onUpdateDestination(UpdateDestination event, Emitter<MapState> emit) {
    emit(state.copyWith(destination: event.destination));
  }

  Future<void> _onUpdateOriginFormattedAddress(
    UpdateOriginFormattedAddress event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final address = await geocoder.findAddressesFromCoordinates(
        Coordinates(event.origin.latitude, event.origin.longitude),
      );
      debugPrint('Fetched origin addresses: ${address.first.addressLine}');
      emit(
        state.copyWith(
          originFormattedAddress: address.first.addressLine,
          loading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          errorMessage: 'Failed to fetch origin address: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateDestinationFormattedAddress(
    UpdateDestinationFormattedAddress event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final address = await geocoder.findAddressesFromCoordinates(
        Coordinates(event.destination.latitude, event.destination.longitude),
      );
      debugPrint('Fetched dest addresses: ${address.first.addressLine}');

      emit(
        state.copyWith(
          destinationFormattedAddress: address.first.addressLine,
          loading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          errorMessage: 'Failed to fetch destination address: ${e.toString()}',
        ),
      );
    }
  }

  void _onUpdatePolylines(UpdatePolylines event, Emitter<MapState> emit) {
    emit(
      state.copyWith(
        polylineCoordinates: event.polylineCoordinates,
        polylines: event.polylines,
      ),
    );
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) {
    emit(state.copyWith(markers: event.markers));
  }

  void _onClearSearchResults(ClearSearchResults event, Emitter<MapState> emit) {
    emit(
      state.copyWith(
        searchResults: const GetPlace(predictions: [], status: ''),
      ),
    );
  }

  void _onClearPolylines(ClearPolylines event, Emitter<MapState> emit) {
    emit(state.copyWith(polylines: {}, polylineCoordinates: []));
  }

  void _onClearMapRoute(ClearMapRoute event, Emitter<MapState> emit) {
    emit(state.copyWith(polylines: {}, polylineCoordinates: [], markers: {}));
  }

  Future<void> _onFetchDirections(
    FetchDirections event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(directionsLoading: true));

    final result = await _getDirectionsUsecase(
      GetDirectionsParams(
        originLat: event.origin.latitude,
        originLng: event.origin.longitude,
        destinationLat: event.destination.latitude,
        destinationLng: event.destination.longitude,
      ),
    );

    result.fold(
      (failure) {
        debugPrint('Directions fetch failure: ${failure.toString()}');
        emit(
          state.copyWith(
            directionsLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (directions) {
        emit(state.copyWith(directionsLoading: false, directions: directions));
      },
    );
  }

  void _onResetMap(ResetMap event, Emitter<MapState> emit) {
    emit(
      state.copyWith(
        destination: null,
        destinationFormattedAddress: '',
        polylineCoordinates: [],
        markers: {},
        polylines: {},
        searchResults: const GetPlace(predictions: [], status: ''),
        searchQuery: '',
        placeDetail: null,
        directions: null,
        errorMessage: null,
        directionsLoading: false,
        loading: false,
      ),
    );
  }
}

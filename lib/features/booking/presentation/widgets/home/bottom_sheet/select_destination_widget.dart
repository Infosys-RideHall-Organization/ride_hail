// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ride_hail/core/utils/google_maps_utility.dart';
// import 'package:toastification/toastification.dart';
//
// import '../../../../../../core/common/widgets/toast.dart';
// import '../../../../../../core/theme/app_palette.dart';
// import '../../../bloc/map/map_bloc.dart';
// import '../../../bloc/stage/booking_stage_cubit.dart';
// import '../outlined_button.dart';
//
// class SelectDestinationWidget extends StatefulWidget {
//   const SelectDestinationWidget({
//     super.key,
//     this.searchPlace,
//     required this.getPolyLines,
//   });
//
//   final void Function(String)? searchPlace;
//   final Future<void> Function(MapState state) getPolyLines;
//
//   @override
//   State<SelectDestinationWidget> createState() =>
//       _SelectDestinationWidgetState();
// }
//
// class _SelectDestinationWidgetState extends State<SelectDestinationWidget> {
//   final searchController = TextEditingController();
//   BitmapDescriptor? destinationMarker;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initDestinationMarker();
//     });
//   }
//
//   Future<void> _initDestinationMarker() async {
//     destinationMarker = await GoogleMapsUtility.getBytesFromAsset(
//       'assets/images/map-pin-2x.png',
//       20,
//     );
//       setState(() {});
//
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MapBloc, MapState>(
//       listener: (context, state) {
//         if (state.destinationFormattedAddress.isNotEmpty &&
//             state.originFormattedAddress.isNotEmpty) {
//           context.read<BookingStageCubit>().nextStage();
//         }
//       },
//       child: BlocBuilder<MapBloc, MapState>(
//         builder: (context, state) {
//           final hasSearchResults = state.searchResults.predictions.isNotEmpty;
//           return Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 32.0,
//               horizontal: 32.0,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Where to?', style: TextStyle(fontSize: 24.0)),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: searchController,
//                   onChanged: widget.searchPlace,
//                   decoration: InputDecoration(
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         FocusScope.of(context).unfocus();
//                         context.read<MapBloc>().add(ClearSearchResults());
//                         searchController.clear();
//                       },
//                       icon: const Icon(Icons.clear),
//                     ),
//                     hintText: 'Search Location',
//                     icon: const Icon(Icons.search),
//                     filled: true,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: AppPalette.greyColor.withAlpha(150),
//                       ),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppPalette.greyColor),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 if (hasSearchResults)
//                   Expanded(
//                     flex: 1,
//                     child: ListView.builder(
//                       itemCount: state.searchResults.predictions.length,
//                       itemBuilder: (context, index) {
//                         final prediction =
//                             state.searchResults.predictions[index];
//                         return ListTile(
//                           title: Text(prediction.description),
//                           onTap: () async {
//                             context.read<MapBloc>().add(ClearMapRoute());
//                             final placeId = prediction.placeId;
//
//                             context.read<MapBloc>().add(
//                               SelectPlaceFromSearch(placeId),
//                             );
//
//                             late StreamSubscription<MapState> subscription;
//
//                             subscription = context
//                                 .read<MapBloc>()
//                                 .stream
//                                 .listen((newState) async {
//                                   final placeDetails = newState.placeDetail;
//                                   final placeLat =
//                                       placeDetails
//                                           ?.result
//                                           ?.geometry
//                                           ?.location
//                                           ?.lat;
//                                   final placeLng =
//                                       placeDetails
//                                           ?.result
//                                           ?.geometry
//                                           ?.location
//                                           ?.lng;
//
//                                   if (placeLat != null && placeLng != null) {
//                                     await subscription.cancel();
//
//                                     searchController.text =
//                                         placeDetails
//                                             ?.result
//                                             ?.formattedAddress ??
//                                         '';
//
//                                     final destination = LatLng(
//                                       placeLat,
//                                       placeLng,
//                                     );
//
//                                     if (context.mounted) {
//                                       context.read<MapBloc>().add(
//                                         UpdateDestination(destination),
//                                       );
//                                       context.read<MapBloc>().add(
//                                         UpdateMarkers({
//                                           Marker(
//                                             markerId: const MarkerId(
//                                               'destination',
//                                             ),
//                                             position: destination,
//                                           ),
//                                         }),
//                                       );
//                                       await widget.getPolyLines(
//                                         context.read<MapBloc>().state.copyWith(
//                                           destination: destination,
//                                         ),
//                                       );
//                                       context.read<MapBloc>().add(
//                                         ClearSearchResults(),
//                                       );
//                                     }
//                                   }
//                                 });
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 const SizedBox(height: 16.0),
//                 GestureDetector(
//                   onTap:
//                       destinationMarker == null
//                           ? null
//                           : () {
//                             debugPrint('Clicked on select from map');
//                             searchController.clear();
//
//                             if (state.origin == null) {
//                               showToast(
//                                 context: context,
//                                 type: ToastificationType.info,
//                                 description: 'We are getting your location...',
//                               );
//                               return;
//                             }
//
//                             context.read<MapBloc>().add(ClearMapRoute());
//
//                             final markerSet = <Marker>{
//                               Marker(
//                                 markerId: const MarkerId('destination'),
//                                 icon: destinationMarker!,
//                                 draggable: true,
//                                 position: state.origin!,
//                                 onDragStart: (_) {
//                                   context.read<MapBloc>().add(ClearPolylines());
//                                 },
//                                 onDragEnd: (value) async {
//                                   final newDestination = LatLng(
//                                     value.latitude,
//                                     value.longitude,
//                                   );
//                                   context.read<MapBloc>().add(
//                                     UpdateDestination(newDestination),
//                                   );
//                                   Future.delayed(
//                                     const Duration(milliseconds: 100),
//                                     () async {
//                                       if (context.mounted) {
//                                         await widget.getPolyLines(
//                                           context.read<MapBloc>().state,
//                                         );
//                                       }
//                                     },
//                                   );
//                                 },
//                               ),
//                             };
//
//                             context.read<MapBloc>().add(
//                               UpdateMarkers(markerSet),
//                             );
//                           },
//                   child: Opacity(
//                     opacity: destinationMarker == null ? 0.5 : 1.0,
//                     child: Row(
//                       children: [
//                         Image.asset('assets/images/select-from-map.png'),
//                         const SizedBox(width: 16.0),
//                         const Text(
//                           'Select from map',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 if (state.origin != null && state.destination != null)
//                   Center(
//                     child: CustomOutlinedButton(
//                       onPressed: () async {
//                         final destination = state.destination;
//                         final origin = state.origin;
//                         debugPrint("Origin $origin");
//                         debugPrint("Destination $destination");
//
//                         context.read<MapBloc>().add(
//                           UpdateOriginFormattedAddress(origin!),
//                         );
//                         context.read<MapBloc>().add(
//                           UpdateDestinationFormattedAddress(destination!),
//                         );
//
//                         if (searchController.text.isNotEmpty) {
//                           searchController.clear();
//                         }
//                       },
//                       buttonName: 'Next',
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../core/common/widgets/toast.dart';
import '../../../../../../core/theme/app_palette.dart';
import '../../../bloc/map/map_bloc.dart';
import '../../../bloc/stage/booking_stage_cubit.dart';
import '../outlined_button.dart';

class SelectDestinationWidget extends StatefulWidget {
  const SelectDestinationWidget({
    super.key,
    this.searchPlace,
    required this.getPolyLines,
  });

  final void Function(String)? searchPlace;
  final Future<void> Function(MapState state) getPolyLines;

  @override
  State<SelectDestinationWidget> createState() =>
      _SelectDestinationWidgetState();
}

class _SelectDestinationWidgetState extends State<SelectDestinationWidget> {
  final searchController = TextEditingController();
  // BitmapDescriptor? destinationMarker;
  late MapBloc _mapBloc;
  StreamSubscription<MapState>? _mapSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _initDestinationMarker();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store a reference to the MapBloc to avoid accessing it through context after dispose
    _mapBloc = context.read<MapBloc>();
  }

  // Future<void> _initDestinationMarker() async {
  //   if (_isDisposed) return;
  //
  //   destinationMarker = await GoogleMapsUtility.getBytesFromAsset(
  //     'assets/images/map-pin-2x.png',
  //     20,
  //   );
  //
  //   if (!_isDisposed) {
  //     setState(() {});
  //   }
  // }

  @override
  void dispose() {
    searchController.dispose();
    _mapSubscription?.cancel();
    _isDisposed = true;
    super.dispose();
  }

  // Safe way to update the MapBloc state
  void _safeUpdateMapBloc(void Function(MapBloc bloc) action) {
    if (!_isDisposed) {
      action(_mapBloc);
    }
  }

  // Safe way to get polylines
  Future<void> _safeGetPolyLines(MapState state) async {
    if (!_isDisposed && mounted) {
      await widget.getPolyLines(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        if (state.destinationFormattedAddress.isNotEmpty &&
            state.originFormattedAddress.isNotEmpty) {
          context.read<BookingStageCubit>().nextStage();
        }
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final hasSearchResults = state.searchResults.predictions.isNotEmpty;
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Where to?', style: TextStyle(fontSize: 24.0)),
                const SizedBox(height: 16.0),
                TextField(
                  controller: searchController,
                  onChanged: widget.searchPlace,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _safeUpdateMapBloc(
                          (bloc) => bloc.add(ClearSearchResults()),
                        );
                        searchController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    hintText: 'Search Location',
                    icon: const Icon(Icons.search),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppPalette.greyColor.withAlpha(150),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppPalette.greyColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                if (hasSearchResults)
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: state.searchResults.predictions.length,
                      itemBuilder: (context, index) {
                        final prediction =
                            state.searchResults.predictions[index];
                        return ListTile(
                          title: Text(prediction.description),
                          onTap: () async {
                            _safeUpdateMapBloc(
                              (bloc) => bloc.add(ClearMapRoute()),
                            );
                            final placeId = prediction.placeId;

                            _safeUpdateMapBloc(
                              (bloc) =>
                                  bloc.add(SelectPlaceFromSearch(placeId)),
                            );

                            // Cancel any existing subscription
                            await _mapSubscription?.cancel();

                            // Create a new subscription
                            _mapSubscription = _mapBloc.stream.listen((
                              newState,
                            ) async {
                              if (_isDisposed) {
                                await _mapSubscription?.cancel();
                                return;
                              }

                              final placeDetails = newState.placeDetail;
                              final placeLat =
                                  placeDetails?.result?.geometry?.location?.lat;
                              final placeLng =
                                  placeDetails?.result?.geometry?.location?.lng;

                              if (placeLat != null && placeLng != null) {
                                await _mapSubscription?.cancel();
                                _mapSubscription = null;

                                if (_isDisposed) return;

                                searchController.text =
                                    placeDetails?.result?.formattedAddress ??
                                    '';

                                final destination = LatLng(placeLat, placeLng);

                                if (mounted) {
                                  _safeUpdateMapBloc(
                                    (bloc) => bloc.add(
                                      UpdateDestination(destination),
                                    ),
                                  );

                                  _safeUpdateMapBloc(
                                    (bloc) => bloc.add(
                                      UpdateMarkers({
                                        Marker(
                                          markerId: const MarkerId(
                                            'destination',
                                          ),
                                          position: destination,
                                        ),
                                      }),
                                    ),
                                  );

                                  await _safeGetPolyLines(
                                    _mapBloc.state.copyWith(
                                      destination: destination,
                                    ),
                                  );

                                  _safeUpdateMapBloc(
                                    (bloc) => bloc.add(ClearSearchResults()),
                                  );
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap:
                  // destinationMarker == null
                  //     ? null
                  //     :
                  () {
                    debugPrint('Clicked on select from map');
                    searchController.clear();

                    if (state.origin == null) {
                      showToast(
                        context: context,
                        type: ToastificationType.info,
                        description: 'We are getting your location...',
                      );
                      return;
                    }

                    _safeUpdateMapBloc((bloc) => bloc.add(ClearMapRoute()));

                    // Store marker data and callbacks locally
                    final MapBloc bloc = _mapBloc;
                    final origin = state.origin!;

                    // Create a marker with safe callbacks
                    final markerSet = <Marker>{
                      Marker(
                        markerId: const MarkerId('destination'),
                        icon: BitmapDescriptor.defaultMarker,
                        draggable: true,
                        position: origin,
                        onDragStart: (_) {
                          // Use the stored bloc reference instead of context
                          if (!_isDisposed) {
                            bloc.add(ClearPolylines());
                          }
                        },
                        onDragEnd: (value) async {
                          // Only proceed if the widget is still mounted
                          if (_isDisposed) return;

                          final newDestination = LatLng(
                            value.latitude,
                            value.longitude,
                          );

                          // Use the stored bloc reference instead of context
                          bloc.add(UpdateDestination(newDestination));

                          // Delay to ensure state updates
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () async {
                              if (!_isDisposed && mounted) {
                                await widget.getPolyLines(bloc.state);
                              }
                            },
                          );
                        },
                      ),
                    };

                    _safeUpdateMapBloc(
                      (bloc) => bloc.add(UpdateMarkers(markerSet)),
                    );
                  },
                  child: Opacity(
                    opacity: 1.0,
                    child: Row(
                      children: [
                        Image.asset('assets/images/select-from-map.png'),
                        const SizedBox(width: 16.0),
                        Text(
                          (state.origin != null && state.destination != null)
                              ? 'Change Destination From Map'
                              : 'Select Destination From Map',

                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                if (state.origin != null && state.destination != null)
                  Center(
                    child: CustomOutlinedButton(
                      onPressed: () async {
                        final destination = state.destination;
                        final origin = state.origin;
                        debugPrint("Origin $origin");
                        debugPrint("Destination $destination");

                        _safeUpdateMapBloc(
                          (bloc) =>
                              bloc.add(UpdateOriginFormattedAddress(origin!)),
                        );

                        _safeUpdateMapBloc(
                          (bloc) => bloc.add(
                            UpdateDestinationFormattedAddress(destination!),
                          ),
                        );

                        if (searchController.text.isNotEmpty) {
                          searchController.clear();
                        }
                      },
                      buttonName: 'Next',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class FareCalculatorUtil {
  static final double baseFare = 20.0; // base fare
  static final double perKmRate = 5.0; // per km rate

  static final double perUnitRate = 5.0;
  static double calculateDistanceInKm(LatLng? start, LatLng? end) {
    if (start == null || end == null) return 0.0;

    const double earthRadius = 6371; // km
    double dLat = (end.latitude - start.latitude) * (pi / 180.0);
    double dLng = (end.longitude - start.longitude) * (pi / 180.0);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(start.latitude * (pi / 180.0)) *
            cos(end.latitude * (pi / 180.0)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double calculateFare(
    LatLng? start,
    LatLng? end,
    int passengers,
    int weights,
  ) {
    final distance = calculateDistanceInKm(start, end);
    return baseFare +
        (perKmRate * distance) +
        (passengers * perUnitRate) +
        (weights * perUnitRate);
  }
}

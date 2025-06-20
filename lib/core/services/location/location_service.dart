import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/common/widgets/dialog_helper.dart';

class LocationService {
  static Future<Position?> getLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (!serviceEnabled ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          final openSettings = await DialogHelper.showLocationErrorDialog(
            context,
            'Location permission permanently denied.',
          );
          if (openSettings) {
            await Geolocator.openAppSettings();
          }
          return null;
        }
      }

      if (permission == LocationPermission.denied) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      if (context.mounted) {
        final retry = await DialogHelper.showLocationErrorDialog(
          context,
          e.toString(),
        );
        if (retry) {
          await Geolocator.openAppSettings();
        }
        return null;
      }
    }
    return null;
  }
}

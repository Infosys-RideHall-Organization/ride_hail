import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/routes/app_routes.dart';
import 'package:ride_hail/core/theme/app_palette.dart';

import '../../../../core/services/location/location_service.dart';

class LocationGatePage extends StatefulWidget {
  const LocationGatePage({super.key});

  @override
  State<LocationGatePage> createState() => _LocationGatePageState();
}

class _LocationGatePageState extends State<LocationGatePage> {
  bool _isLoading = false;

  Future<void> requestPermissionFlow() async {
    setState(() => _isLoading = true);
    final position = await LocationService.getLocation(context);
    setState(() => _isLoading = false);

    if (position != null) {
      // Navigate or proceed as needed here
      debugPrint('Granted');
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isLoading
                ? CustomLoadingIndicator()
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 20.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 80,
                        color: AppPalette.primaryColor,
                      ),
                      const Text(
                        'Allow your location',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'We will need your location to provide services and give you a better experience',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: requestPermissionFlow,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Enable Location',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

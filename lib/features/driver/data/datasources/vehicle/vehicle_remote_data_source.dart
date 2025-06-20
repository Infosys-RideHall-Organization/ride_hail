import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/vehicle/vehicle_model.dart';

abstract interface class VehicleRemoteDataSource {
  Future<VehicleModel> fetchVehicleByDriverId(String driverId);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  @override
  Future<VehicleModel> fetchVehicleByDriverId(String driverId) async {
    final response = await http.get(
      Uri.parse('${Constants.backendUrl}/vehicle/driver/$driverId'),
    );
    debugPrint('Response = ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final vehicleMap = decoded['vehicle'] as Map<String, dynamic>;

      return VehicleModel.fromMap(vehicleMap);
    } else {
      throw ServerException(message: 'Failed to load vehicle for driver');
    }
  }
}

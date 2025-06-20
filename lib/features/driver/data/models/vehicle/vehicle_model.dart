import 'dart:convert';

import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/vehicle/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.type,
    required super.identifier,
    required super.passengerCapacity,
    required super.weightCapacity,
    required super.latitude,
    required super.longitude,
    required super.isBooked,
    super.driver,
  });

  factory VehicleModel.fromJson(String json) {
    return VehicleModel.fromMap(jsonDecode(json));
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['_id'],
      type: map['type'],
      identifier: map['identifier'],
      passengerCapacity: (map['capacity']['passengers'] as num).toInt(),
      weightCapacity: (map['capacity']['weight'] as num).toInt(),
      latitude: (map['currentLocation']['lat'] as num).toDouble(),
      longitude: (map['currentLocation']['lng'] as num).toDouble(),
      isBooked: map['isBooked'],
      driver: map['driver'] != null ? UserModel.fromMap(map['driver']) : null,
    );
  }
}

import 'package:equatable/equatable.dart';

import '../../../../../core/entities/auth/user.dart';

class Vehicle extends Equatable {
  final String id;
  final String type;
  final String identifier;
  final int passengerCapacity;
  final int weightCapacity;
  final double latitude;
  final double longitude;
  final bool isBooked;
  final User? driver;

  const Vehicle({
    required this.id,
    required this.type,
    required this.identifier,
    required this.passengerCapacity,
    required this.weightCapacity,
    required this.latitude,
    required this.longitude,
    required this.isBooked,
    this.driver,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    identifier,
    passengerCapacity,
    weightCapacity,
    latitude,
    longitude,
    isBooked,
    driver,
  ];
}

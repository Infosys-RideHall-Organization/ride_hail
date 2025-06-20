import 'package:equatable/equatable.dart';

import '../campus/campus.dart';

class Location extends Equatable {
  final double lat;
  final double lng;

  const Location({required this.lat, required this.lng});

  @override
  List<Object> get props => [lat, lng];
}

class Passenger extends Equatable {
  final String name;
  final String phoneNo;
  final String email;
  final String companyName;

  const Passenger({
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.companyName,
  });

  @override
  List<Object> get props => [name, phoneNo, email, companyName];
}

class WeightItem extends Equatable {
  final String name;
  final double weight;

  const WeightItem({required this.name, required this.weight});

  @override
  List<Object> get props => [name, weight];
}

class Booking extends Equatable {
  final String id;
  final String userId;

  final Campus campus;
  final Location origin;
  final String originAddress;
  final Location destination;
  final String destinationAddress;
  final String vehicleType;
  final String? vehicleId;
  final DateTime schedule;
  final String status;

  final String otp;
  final bool otpVerified;
  final List<Passenger> passengers;
  final List<WeightItem> weightItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.campus,
    required this.origin,
    required this.originAddress,
    required this.destination,
    required this.destinationAddress,
    required this.vehicleType,
    required this.vehicleId,
    required this.schedule,
    required this.status,
    required this.otp,
    required this.otpVerified,
    required this.passengers,
    required this.weightItems,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    campus,
    origin,
    originAddress,
    destination,
    destinationAddress,
    vehicleType,
    vehicleId,
    schedule,
    status,
    otp,
    otpVerified,
    passengers,
    weightItems,
    createdAt,
    updatedAt,
  ];
}

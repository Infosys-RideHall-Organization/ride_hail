import 'dart:convert';

import 'package:ride_hail/features/booking/data/models/campus/campus_model.dart';

import '../../../domain/entities/booking/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.campus,
    required super.origin,
    required super.originAddress,
    required super.destination,
    required super.destinationAddress,
    required super.vehicleType,
    required super.vehicleId,
    required super.schedule,
    required super.status,
    required super.otp,
    required super.otpVerified,
    required super.passengers,
    required super.weightItems,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingModel.fromJson(String json) {
    return BookingModel.fromMap(jsonDecode(json));
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['_id'],
      userId: map['userId'],
      campus: CampusModel.fromMap(map['campus']),
      origin: LocationModel.fromMap(map['origin']),
      originAddress: map['originAddress'],
      destination: LocationModel.fromMap(map['destination']),
      destinationAddress: map['destinationAddress'],
      vehicleType: map['vehicleType'],
      vehicleId: map['vehicleId'],
      schedule: DateTime.parse(map['schedule']),
      status: map['status'],
      otp: map['otp'],
      otpVerified: map['otpVerified'],
      passengers:
          (map['passengers'] as List)
              .map((p) => PassengerModel.fromMap(p))
              .toList(),
      weightItems:
          (map['weightItems'] as List)
              .map((w) => WeightItemModel.fromMap(w))
              .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'campus': (campus.id),
      'origin': (origin as LocationModel).toMap(),
      'originAddress': originAddress,
      'destination': (destination as LocationModel).toMap(),
      'destinationAddress': destinationAddress,
      'vehicleType': vehicleType,
      'vehicleId': vehicleId,
      'schedule': schedule.toIso8601String(),
      'status': status,
      'otp': otp,
      'otpVerified': otpVerified,
      'passengers':
          passengers.map((p) => (p as PassengerModel).toMap()).toList(),
      'weightItems':
          weightItems.map((w) => (w as WeightItemModel).toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());
}

class PassengerModel extends Passenger {
  const PassengerModel({
    required super.name,
    required super.phoneNo,
    required super.email,
    required super.companyName,
  });

  factory PassengerModel.fromJson(String json) {
    return PassengerModel.fromMap(jsonDecode(json));
  }

  factory PassengerModel.fromMap(Map<String, dynamic> map) {
    return PassengerModel(
      name: map['name'],
      phoneNo: map['phoneNo'],
      email: map['email'],
      companyName: map['companyName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNo': phoneNo,
      'email': email,
      'companyName': companyName,
    };
  }

  String toJson() => jsonEncode(toMap());
}

class WeightItemModel extends WeightItem {
  const WeightItemModel({required super.name, required super.weight});

  factory WeightItemModel.fromJson(String json) {
    return WeightItemModel.fromMap(jsonDecode(json));
  }

  factory WeightItemModel.fromMap(Map<String, dynamic> map) {
    return WeightItemModel(
      name: map['name'],
      weight: (map['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'weight': weight};
  }

  String toJson() => jsonEncode(toMap());
}

class LocationModel extends Location {
  const LocationModel({required super.lat, required super.lng});

  factory LocationModel.fromJson(String json) {
    return LocationModel.fromMap(jsonDecode(json));
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'lat': lat, 'lng': lng};
  }

  String toJson() => jsonEncode(toMap());
}

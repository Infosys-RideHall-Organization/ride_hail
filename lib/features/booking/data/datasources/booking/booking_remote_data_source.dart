import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/booking/booking_model.dart';

abstract interface class BookingRemoteDataSource {
  Future<BookingModel> createBooking({
    required String userId,
    required String campusId,
    required LatLng origin,
    required String originAddress,
    required LatLng destination,
    required String destinationAddress,
    required String vehicleType,
    required List<PassengerModel> passengers,
    required List<WeightItemModel> weightItems,
    required DateTime schedule,
  });

  Future<BookingModel> getBookingById({required String bookingId});

  Future<List<BookingModel>> getPastBookings({required String userId});
  Future<List<BookingModel>> getUpcomingBookings({required String userId});

  Future<BookingModel> assignVehicleUsingBookingId({required String bookingId});

  Future<BookingModel> verifyBookingOtp({
    required String bookingId,
    required String otp,
  });

  Future<BookingModel> cancelBooking({required String bookingId});

  Future<BookingModel> emergencyStopBooking({
    required String bookingId,
    required String reason,
  });

  Future<BookingModel> completeBooking({required String bookingId});
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  @override
  Future<BookingModel> createBooking({
    required String userId,
    required String campusId,
    required LatLng origin,
    required String originAddress,
    required LatLng destination,
    required String destinationAddress,
    required String vehicleType,
    required List<PassengerModel> passengers,
    required List<WeightItemModel> weightItems,
    required DateTime schedule,
  }) async {
    try {
      final uri = Uri.parse('${Constants.backendUrl}/booking');

      final requestBody = {
        "userId": userId,
        "campus": campusId,
        "origin": {"lat": origin.latitude, "lng": origin.longitude},
        "originAddress": originAddress,
        "destination": {
          "lat": destination.latitude,
          "lng": destination.longitude,
        },
        "destinationAddress": destinationAddress,
        "vehicleType": vehicleType,
        "schedule": schedule.toUtc().toIso8601String(),
        "passengers": passengers.map((passenger) => passenger.toMap()).toList(),
        "weightItems":
            weightItems.map((weightItem) => weightItem.toMap()).toList(),
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookingModel> getBookingById({required String bookingId}) async {
    try {
      final uri = Uri.parse('${Constants.backendUrl}/booking/$bookingId');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookingModel> assignVehicleUsingBookingId({
    required String bookingId,
  }) async {
    try {
      final uri = Uri.parse(
        '${Constants.backendUrl}/booking/assign-vehicle/$bookingId',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookingModel> verifyBookingOtp({
    required String bookingId,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse(
        '${Constants.backendUrl}/booking/verify-otp/$bookingId',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp}),
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint('Otp verified');
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookingModel> cancelBooking({required String bookingId}) async {
    try {
      final uri = Uri.parse(
        '${Constants.backendUrl}/booking/cancel/$bookingId',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookingModel> emergencyStopBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final uri = Uri.parse(
        '${Constants.backendUrl}/booking/emergency-stop/$bookingId',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"reason": reason}),
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookingModel> completeBooking({required String bookingId}) async {
    try {
      final uri = Uri.parse(
        '${Constants.backendUrl}/booking/complete/$bookingId',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return BookingModel.fromMap(json['booking']);
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookingModel>> getPastBookings({required String userId}) async {
    try {
      final uri = Uri.parse('${Constants.backendUrl}/booking/past/$userId');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (json['bookings'] as List<dynamic>)
            .map((e) => BookingModel.fromMap(e))
            .toList();
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookingModel>> getUpcomingBookings({
    required String userId,
  }) async {
    try {
      final uri = Uri.parse('${Constants.backendUrl}/booking/upcoming/$userId');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Booking Response: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (json['bookings'] as List<dynamic>)
            .map((e) => BookingModel.fromMap(e))
            .toList();
      } else {
        throw ServerException(
          message: json['error'] ?? 'Unknown booking error',
        );
      }
    } catch (e) {
      debugPrint('Booking Error: $e');
      throw ServerException(message: e.toString());
    }
  }
}

import 'dart:convert';

import '../../../domain/entities/campus/campus.dart';

class CampusModel extends Campus {
  const CampusModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
  });

  factory CampusModel.fromJson(String json) {
    return CampusModel.fromMap(jsonDecode(json));
  }

  factory CampusModel.fromMap(Map<String, dynamic> map) {
    return CampusModel(
      id: map['_id'],
      name: map['name'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }
}

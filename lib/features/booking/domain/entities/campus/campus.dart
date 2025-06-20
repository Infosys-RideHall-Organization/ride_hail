import 'package:equatable/equatable.dart';

class Campus extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const Campus({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [id, name, latitude, longitude];
}

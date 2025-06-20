import 'package:equatable/equatable.dart';

class PlaceDetail extends Equatable {
  final Result? result;
  final String? status;

  const PlaceDetail({this.result, this.status});

  @override
  List<Object?> get props => [result, status];

  @override
  String toString() => 'PlaceDetail(result: $result, status: $status)';
}

class Result extends Equatable {
  final List<AddressComponent>? addressComponents;
  final String? adrAddress;
  final String? formattedAddress;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final String? placeId;
  final PlusCode? plusCode;
  final String? reference;
  final List<String>? types;
  final String? url;
  final int? utcOffset;
  final String? vicinity;

  const Result({
    this.addressComponents,
    this.adrAddress,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.placeId,
    this.plusCode,
    this.reference,
    this.types,
    this.url,
    this.utcOffset,
    this.vicinity,
  });

  @override
  List<Object?> get props => [
    addressComponents,
    adrAddress,
    formattedAddress,
    geometry,
    icon,
    iconBackgroundColor,
    iconMaskBaseUri,
    name,
    placeId,
    plusCode,
    reference,
    types,
    url,
    utcOffset,
    vicinity,
  ];
}

class AddressComponent extends Equatable {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  const AddressComponent({this.longName, this.shortName, this.types});

  @override
  List<Object?> get props => [longName, shortName, types];
}

class Geometry extends Equatable {
  final Location? location;
  final Viewport? viewport;

  const Geometry({this.location, this.viewport});

  @override
  List<Object?> get props => [location, viewport];
}

class Location extends Equatable {
  final double? lat;
  final double? lng;

  const Location({this.lat, this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

class Viewport extends Equatable {
  final Location? northeast;
  final Location? southwest;

  const Viewport({this.northeast, this.southwest});

  @override
  List<Object?> get props => [northeast, southwest];
}

class PlusCode extends Equatable {
  final String? compoundCode;
  final String? globalCode;

  const PlusCode({this.compoundCode, this.globalCode});

  @override
  List<Object?> get props => [compoundCode, globalCode];
}

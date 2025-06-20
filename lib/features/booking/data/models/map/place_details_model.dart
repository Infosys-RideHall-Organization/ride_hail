import 'dart:convert';

import '../../../domain/entities/map/place_details.dart';

class PlaceDetailModel extends PlaceDetail {
  const PlaceDetailModel({super.result, super.status});

  factory PlaceDetailModel.fromJson(String json) =>
      PlaceDetailModel.fromMap(jsonDecode(json));
  factory PlaceDetailModel.fromMap(Map<String, dynamic> json) {
    return PlaceDetailModel(
      result:
          json['result'] != null ? ResultModel.fromMap(json['result']) : null,
      status: json['status'],
    );
  }
}

class ResultModel extends Result {
  const ResultModel({
    super.addressComponents,
    super.adrAddress,
    super.formattedAddress,
    super.geometry,
    super.icon,
    super.iconBackgroundColor,
    super.iconMaskBaseUri,
    super.name,
    super.placeId,
    super.plusCode,
    super.reference,
    super.types,
    super.url,
    super.utcOffset,
    super.vicinity,
  });

  factory ResultModel.fromMap(Map<String, dynamic> json) {
    return ResultModel(
      addressComponents:
          (json['address_components'] as List?)
              ?.map((e) => AddressComponentModel.fromMap(e))
              .toList(),
      adrAddress: json['adr_address'],
      formattedAddress: json['formatted_address'],
      geometry:
          json['geometry'] != null
              ? GeometryModel.fromMap(json['geometry'])
              : null,
      icon: json['icon'],
      iconBackgroundColor: json['icon_background_color'],
      iconMaskBaseUri: json['icon_mask_base_uri'],
      name: json['name'],
      placeId: json['place_id'],
      plusCode:
          json['plus_code'] != null
              ? PlusCodeModel.fromMap(json['plus_code'])
              : null,
      reference: json['reference'],
      types: (json['types'] as List?)?.map((e) => e.toString()).toList(),
      url: json['url'],
      utcOffset: json['utc_offset'],
      vicinity: json['vicinity'],
    );
  }
}

class AddressComponentModel extends AddressComponent {
  const AddressComponentModel({super.longName, super.shortName, super.types});

  factory AddressComponentModel.fromMap(Map<String, dynamic> json) {
    return AddressComponentModel(
      longName: json['long_name'],
      shortName: json['short_name'],
      types: (json['types'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}

class GeometryModel extends Geometry {
  const GeometryModel({super.location, super.viewport});

  factory GeometryModel.fromMap(Map<String, dynamic> json) {
    return GeometryModel(
      location:
          json['location'] != null
              ? LocationModel.fromMap(json['location'])
              : null,
      viewport:
          json['viewport'] != null
              ? ViewportModel.fromMap(json['viewport'])
              : null,
    );
  }
}

class LocationModel extends Location {
  const LocationModel({super.lat, super.lng});

  factory LocationModel.fromMap(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }
}

class ViewportModel extends Viewport {
  const ViewportModel({super.northeast, super.southwest});

  factory ViewportModel.fromMap(Map<String, dynamic> json) {
    return ViewportModel(
      northeast:
          json['northeast'] != null
              ? LocationModel.fromMap(json['northeast'])
              : null,
      southwest:
          json['southwest'] != null
              ? LocationModel.fromMap(json['southwest'])
              : null,
    );
  }
}

class PlusCodeModel extends PlusCode {
  const PlusCodeModel({super.compoundCode, super.globalCode});

  factory PlusCodeModel.fromMap(Map<String, dynamic> json) {
    return PlusCodeModel(
      compoundCode: json['compound_code'],
      globalCode: json['global_code'],
    );
  }
}

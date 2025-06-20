import 'dart:convert';

import '../../../domain/entities/map/get_places.dart';

class GetPlaceModel extends GetPlace {
  const GetPlaceModel({required super.predictions, required super.status});

  factory GetPlaceModel.fromJson(String json) =>
      GetPlaceModel.fromMap(jsonDecode(json));

  factory GetPlaceModel.fromMap(Map<String, dynamic> map) {
    return GetPlaceModel(
      predictions:
          (map['predictions'] as List<dynamic>?)
              ?.map((e) => PredictionModel.fromMap(e))
              .toList() ??
          [],
      status: map['status'] ?? '',
    );
  }
}

class PredictionModel extends Prediction {
  const PredictionModel({
    required super.description,
    required super.matchedSubstrings,
    required super.placeId,
    required super.reference,
    required super.structuredFormatting,
    required super.terms,
    required super.types,
  });

  factory PredictionModel.fromMap(Map<String, dynamic> map) {
    return PredictionModel(
      description: map['description'] ?? '',
      matchedSubstrings:
          (map['matched_substrings'] as List<dynamic>?)
              ?.map((e) => MatchedSubstringModel.fromMap(e))
              .toList() ??
          [],
      placeId: map['place_id'] ?? '',
      reference: map['reference'] ?? '',
      structuredFormatting: StructuredFormattingModel.fromMap(
        map['structured_formatting'] ?? {},
      ),
      terms:
          (map['terms'] as List<dynamic>?)
              ?.map((e) => TermModel.fromMap(e))
              .toList() ??
          [],
      types:
          (map['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

class MatchedSubstringModel extends MatchedSubstring {
  const MatchedSubstringModel({required super.length, required super.offset});

  factory MatchedSubstringModel.fromMap(Map<String, dynamic> map) {
    return MatchedSubstringModel(
      length: map['length'] ?? 0,
      offset: map['offset'] ?? 0,
    );
  }
}

class StructuredFormattingModel extends StructuredFormatting {
  const StructuredFormattingModel({
    required super.mainText,
    required super.mainTextMatchedSubstrings,
    required super.secondaryText,
  });

  factory StructuredFormattingModel.fromMap(Map<String, dynamic> map) {
    return StructuredFormattingModel(
      mainText: map['main_text'] ?? '',
      mainTextMatchedSubstrings:
          (map['main_text_matched_substrings'] as List<dynamic>?)
              ?.map((e) => MatchedSubstringModel.fromMap(e))
              .toList() ??
          [],
      secondaryText: map['secondary_text'] ?? '',
    );
  }
}

class TermModel extends Term {
  const TermModel({required super.offset, required super.value});

  factory TermModel.fromMap(Map<String, dynamic> map) {
    return TermModel(offset: map['offset'] ?? 0, value: map['value'] ?? '');
  }
}

import 'package:equatable/equatable.dart';

class GetPlace extends Equatable {
  final List<Prediction> predictions;
  final String status;

  const GetPlace({required this.predictions, required this.status});

  @override
  List<Object?> get props => [predictions, status];

  @override
  String toString() => 'GetPlace(predictions: $predictions, status: $status)';
}

class Prediction extends Equatable {
  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  const Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  @override
  List<Object?> get props => [
    description,
    matchedSubstrings,
    placeId,
    reference,
    structuredFormatting,
    terms,
    types,
  ];

  @override
  String toString() =>
      'Prediction(description: $description, placeId: $placeId)';
}

class MatchedSubstring extends Equatable {
  final int length;
  final int offset;

  const MatchedSubstring({required this.length, required this.offset});

  @override
  List<Object?> get props => [length, offset];
}

class StructuredFormatting extends Equatable {
  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  const StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  @override
  List<Object?> get props => [
    mainText,
    mainTextMatchedSubstrings,
    secondaryText,
  ];
}

class Term extends Equatable {
  final int offset;
  final String value;

  const Term({required this.offset, required this.value});

  @override
  List<Object?> get props => [offset, value];
}

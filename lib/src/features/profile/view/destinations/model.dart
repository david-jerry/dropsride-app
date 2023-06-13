import 'dart:convert';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutoCompletePredictions>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'],
      predictions: json['predictions'] != null
          ? json['predictions']
              .map<AutoCompletePredictions>(
                  (json) => AutoCompletePredictions.fromJson(json))
              .toList()
          : null,
    );
  }

  static PlaceAutocompleteResponse parseAutoCompelteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}

class AutoCompletePredictions {
  final String? description;

  final StructuredFormatting? structuredFormatting;

  final String? placeId;

  final String? reference;

  AutoCompletePredictions(
      {this.description,
      this.placeId,
      this.reference,
      this.structuredFormatting});

  factory AutoCompletePredictions.fromJson(Map<String, dynamic> json) {
    return AutoCompletePredictions(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
        mainText: json['main_text'] as String?,
        secondaryText: json['secondary_text'] as String?);
  }
}

import 'package:dropsride/src/features/profile/view/destinations/model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:http/http.dart' as http;

class PlacesAutocompleteRepository extends GetxController {
  static PlacesAutocompleteRepository get instance =>
      Get.put(PlacesAutocompleteRepository());

  RxString? predictions;

  RxList<AutoCompletePredictions> jsonPredictions =
      <AutoCompletePredictions>[].obs;

  void showPredictions(String key, String value) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      'maps/api/place/autocomplete/json',
      {
        'input': value,
        'key': key,
      },
    );

    // fetch the places suggestions
    try {
      final headers = await const GoogleApiHeaders().getHeaders();
      final response = await http.get(uri, headers: headers);

      String? predictions = response.body;

      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutoCompelteResult(predictions);

      jsonPredictions.value = RxList<AutoCompletePredictions>(result.predictions!);
      if (kDebugMode) {
      }
    } catch (e) {
      showErrorMessage(
          'Prediction Error', e.toString(), FontAwesomeIcons.mapPin);
      return;
    }
  }
  //   Prediction? prediction = await PlacesAutocomplete.show(
  //     context: Get.context!,
  //     apiKey: key!,
  //     mode: Mode.fullscreen,
  //     types: [],
  //     strictbounds: false,
  //     language: 'en',
  //   );


  //   if (prediction != null) {
  //     PlacesDetailsResponse details = await GoogleMapsPlaces(
  //       apiKey: key,
  //       apiHeaders: await const GoogleApiHeaders().getHeaders(),
  //     ).getDetailsByPlaceId(prediction.placeId ?? "0");

  //     double latitude = details.result.geometry!.location.lat;
  //     double longitude = details.result.geometry!.location.lng;

  //     LatLng selectedLocation = LatLng(latitude, longitude);

  //     controller.animateCamera(CameraUpdate.newLatLng(selectedLocation));

  //     DestinationController.instance.currentAddress.value =
  //         prediction.description!.toString();
  //   }
  // }
}

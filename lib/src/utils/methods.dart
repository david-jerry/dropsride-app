import 'dart:convert';

import 'package:dropsride/src/features/home/model/directions_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../features/home/controller/map_controller.dart';

class AssistantMethods {
  // ?INFO: get geoCoded address
  static Future<String> searchAddressForGeoCoordinates(
      Position position, context) async {
    String address = '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$GOOGLE_API_KEY');

    final addressResponse = await http.get(url);

    if (json.decode(addressResponse.body)['results'].length > 0) {
      address = json
          .decode(addressResponse.body)['results'][0]['formatted_address']
          .toString();

      Directions userPickupAddress = Directions();
      userPickupAddress.locationName = address;
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
    }
    return address;
  }
}

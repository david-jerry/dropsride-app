import 'package:dropsride/src/features/profile/controller/repository/destination_firebase.dart';
import 'package:dropsride/src/features/profile/controller/repository/places_autocomplete_repository.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/features/profile/view/destinations/add_location_screen.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

final String GOOGLE_API_KEY = dotenv.env['MAP_API_KEY']!;

class DestinationController extends GetxController {
  static DestinationController get instance => Get.put(DestinationController());
  Rx<GoogleMapController?>? mapController;

  RxBool isLoading = true.obs;
  RxBool isGettingLocation = false.obs;
  Rx<LatLng?> latLng = Rx<LatLng?>(const LatLng(0.00, 0.00));
  Location location = Location();
  PermissionStatus? _permissionGranted;
  Rx<geo.Position?> locationData = Rx<geo.Position?>(null);
  RxBool serviceEnabled = false.obs;
  RxBool locationPermissionGranted = false.obs;
  RxString currentAddress = ''.obs;
  RxString title = ''.obs;

  Future<void> getCurrentLocation() async {
    serviceEnabled.value = await location.serviceEnabled();
    if (!serviceEnabled.value) {
      serviceEnabled.value = await location.requestService();

      if (!serviceEnabled.value) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
      locationPermissionGranted.value = true;
    }

    isGettingLocation.value = true;
    locationData.value = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);

    if (locationData.value != null) {
      latLng.value =
          LatLng(locationData.value!.latitude, locationData.value!.longitude);
    }

    isGettingLocation.value = false;
  }

  void openAddDestination() async {
    await getCurrentLocation();
    Get.to(() => AddFavoriteScreen());
  }

  Future<void> getAddressDetail() async {
    if (currentAddress.value.isEmpty) {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.value!.latitude},${locationData.value!.longitude}&key=$GOOGLE_API_KEY');

      final addressResponse = await http.get(url);

      if (json.decode(addressResponse.body)['results'].length > 1) {
        currentAddress.value = json
            .decode(addressResponse.body)['results'][0]['formatted_address']
            .toString();
      } else {
        isGettingLocation.value = false;
        return;
      }
    }
  }

  Future<void> getCordinates() async {
    if (currentAddress.value.isNotEmpty) {
      final encodedAddress = Uri.encodeQueryComponent(currentAddress.value);
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$GOOGLE_API_KEY');

      final addressResponse = await http.get(url);
      final body = jsonDecode(addressResponse.body);

      final results = body['results'];
      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        latLng.value = LatLng(location['lat'], location['lng']);
        mapController?.value!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng.value!, zoom: 18),
          ),
        );
      }
      return;
    }
    return;
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController?.value = controller;
  }

  void searchPlaces(String query) {
    PlacesAutocompleteRepository.instance
        .showPredictions(GOOGLE_API_KEY, query);
  }

  Future<void> createNewLocation(GlobalKey<FormState> formKey) async {
    final controller = Get.put(DestinationRepository());
    isLoading.value = true;

    final destination = FavouriteDestination(
      address: currentAddress.value,
      latitude: latLng.value!.latitude,
      longitude: latLng.value!.longitude,
      title: title.value,
    );

    if (!formKey.currentState!.validate()) {
      showWarningMessage(
          'Validation Error',
          "You must validate all necessary fields before submitting!",
          Icons.text_fields_sharp);

      isLoading.value = false;
      return;
    }

    formKey.currentState!.save();
    formKey.currentState?.reset();

    await controller.createFavoriteDestination(destination);

    Get.back(canPop: true, closeOverlays: true);
    isLoading.value = false;
  }
}

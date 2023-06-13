// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/methods.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

final String GOOGLE_API_KEY = dotenv.env['MAP_API_KEY']!;
const cam = CameraPosition(target: LatLng(37.42839, -122.03845430), zoom: 14);

class MapController extends GetxController {
  static MapController get find => Get.find<MapController>();

  RxBool active = false.obs;
  RxString userPhoto = kPlaceholder.obs;
  Rx<Position> currentUserPosition = Rx<Position>(
    Position(
      accuracy: 0,
      altitude: 0,
      heading: 0,
      latitude: 0.00,
      longitude: 0.00,
      speed: 0,
      speedAccuracy: 0,
      timestamp: DateTime.now(),
      floor: 0,
      isMocked: false,
    ),
  );
  Rx<LatLng> pickLocation = const LatLng(37.42839, -122.03845430).obs;
  Rx<loc.Location> location = loc.Location().obs;
  RxString address = ''.obs;

  var geolocation = Geolocator();

  RxList<LatLng> pLineCoordinatedList = RxList<LatLng>([]);
  RxSet<Polyline> polylineSet = RxSet<Polyline>({});
  RxSet<Marker> markerSet = RxSet<Marker>({});
  RxSet<Circle> circleSet = RxSet<Circle>({});

  RxDouble searchLocationContainerHeight = 220.00.obs;
  RxDouble waitingResponseFromDriverContainerHeight = 0.00.obs;
  RxDouble assignedDriverContainerHeight = 0.00.obs;

  RxBool activeNearbyDriverKeyLoaded = false.obs;

  Rx<BitmapDescriptor> activeNearbyIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow).obs;

  Rx<Completer<GoogleMapController>> controllerGoogleMap =
      Rx<Completer<GoogleMapController>>(Completer());

  Rx<GoogleMapController?> newGoogleMapController =
      Rx<GoogleMapController?>(null);

  @override
  void onInit() async {
    super.onInit();
    currentUserPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void locateUserPosition() async {
    print("running position locator");
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        "Current Latitude and Longitude: ${cPosition.latitude}, ${cPosition.longitude}");
    currentUserPosition.value = cPosition;

    LatLng latLngPosition = LatLng(currentUserPosition.value.latitude,
        currentUserPosition.value.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 17.765, tilt: 0.3);

    newGoogleMapController.value!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeoCoordinates(
            currentUserPosition.value, Get.context);
    print('This is your current address: $humanReadableAddress');
  }

  Future<void> getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation.value.latitude,
        longitude: pickLocation.value.longitude,
        googleMapApiKey: GOOGLE_API_KEY,
      );

      address.value = data.address;
    } catch (e) {
      showErrorMessage(
          'Geocoding Error', e.toString(), FontAwesomeIcons.locationPin);
    }
  }
}

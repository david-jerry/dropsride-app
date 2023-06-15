// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:dropsride/src/constants/placeholder.dart';
import 'package:dropsride/src/features/home/model/directions_model.dart';
import 'package:dropsride/src/features/trips/model/trip_hostory_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/methods.dart';
import 'package:flutter/material.dart';
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
  RxDouble bottomSheetHeight = 220.00.obs;
  RxDouble bottomSheetDragOffset = 0.00.obs;
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
  final TextEditingController dropOffFieldEditingController =
      TextEditingController();
  final TextEditingController pickUpFieldEditingController =
      TextEditingController();

  var geolocation = Geolocator();

  Rx<CameraPosition> cameraPositionDefault = const CameraPosition(
    target: LatLng(37.42839, -122.03845430),
    zoom: 15.4746,
  ).obs;

  RxList<LatLng> pLineCoordinatedList = RxList<LatLng>([]);
  RxSet<Polyline> polylineSet = RxSet<Polyline>({});
  RxSet<Marker> markerSet = RxSet<Marker>({});
  RxSet<Circle> circleSet = RxSet<Circle>({});

  RxDouble waitingResponseFromDriverContainerHeight = 0.00.obs;
  RxDouble assignedDriverContainerHeight = 0.00.obs;

  RxBool activeNearbyDriverKeyLoaded = false.obs;

  Rx<BitmapDescriptor> activeNearbyIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow).obs;

  Rx<Completer<GoogleMapController>> controllerGoogleMap =
      Rx<Completer<GoogleMapController>>(Completer());

  Rx<GoogleMapController?> newGoogleMapController =
      Rx<GoogleMapController?>(null);

  // todo remember to use substring to concatenate the location length
  Rx<Directions?> userPickupLocation = Directions().obs;
  Rx<Directions?> userDropOffLocation = Directions().obs;
  RxInt countTotalTrips = 0.obs;
  RxList<String> historyTripsKeyList = RxList<String>([]);
  RxList<TripsHistoryModel> allTripsHistoryInformationList =
      RxList<TripsHistoryModel>([]);

  void updatePickupLocationAddress(Directions userPickupAddress) {
    userPickupLocation.value = userPickupAddress;
    pickUpFieldEditingController.text = userPickupLocation.value!.locationName!;

    // update();
  }

  void updateDropoffLocationAddress(Directions dropOffPickupAddress) {
    userDropOffLocation.value = dropOffPickupAddress;
    dropOffFieldEditingController.text =
        userDropOffLocation.value!.locationName!;
    // update();
  }

  // @override
  // void onInit() async {
  //   super.onInit();
  //   currentUserPosition.value = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  //   controllerGoogleMap.close();
  //   newGoogleMapController.close();
  // }

  void goToMyLocation() async {
    LatLng latLngPosition = LatLng(currentUserPosition.value.latitude,
        currentUserPosition.value.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 17.765, tilt: 0.3);

    cameraPositionDefault.value = cameraPosition;
    newGoogleMapController.value!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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

    // initializeGeoFireListener();

    // AssistantMethods.readTripsKeyForOnlineUser(context);
  }

  Future<void> getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation.value.latitude,
        longitude: pickLocation.value.longitude,
        googleMapApiKey: GOOGLE_API_KEY,
      );

      Directions userPickupAddress = Directions();
      userPickupAddress.locationName = data.address;
      userPickupAddress.locationLatitude = pickLocation.value.latitude;
      userPickupAddress.locationLongitude = pickLocation.value.longitude;
      address.value = data.address;

      updatePickupLocationAddress(userPickupAddress);
    } catch (e) {
      showErrorMessage(
          'Geocoding Error', e.toString(), FontAwesomeIcons.locationPin);
    }
  }

  Future<void> getDropoffAddressFromText(
      String address) async {
    try {
      GeoData data = await Geocoder2.getDataFromAddress(
        address: address,
        googleMapApiKey: GOOGLE_API_KEY,
      );

      Directions userDropoffAddress = Directions();
      userDropoffAddress.locationName = data.address;
      userDropoffAddress.locationLatitude = data.latitude;
      userDropoffAddress.locationLongitude = data.longitude;

      updateDropoffLocationAddress(userDropoffAddress);
    } catch (e) {
      showErrorMessage(
          'Geocoding Error', e.toString(), FontAwesomeIcons.locationPin);
    }
  }
}

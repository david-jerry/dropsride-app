// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/model/direction_details_info_model.dart';
import 'package:dropsride/src/features/home/model/directions_model.dart';
import 'package:dropsride/src/features/home/model/driver_data.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/trips/controller/repository/location_repository.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';
import 'package:dropsride/src/features/trips/model/trip_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

final String GOOGLE_API_KEY = dotenv.env['MAP_API_KEY']!;
const cam = CameraPosition(target: LatLng(37.42839, -122.03845430), zoom: 14);

class MapController extends GetxController {
  static MapController get find => Get.find<MapController>();

  // custom markers
  Rx<BitmapDescriptor> userIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow).obs;
  Rx<BitmapDescriptor> pickupIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow).obs;
  Rx<BitmapDescriptor> dropoffIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow).obs;
  Rx<BitmapDescriptor> activeNearbyIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow).obs;

  // carTypes

  // map controllers
  Rx<Completer<GoogleMapController>> controllerGoogleMap =
      Rx<Completer<GoogleMapController>>(Completer());
  Rx<GoogleMapController?> newGoogleMapController =
      Rx<GoogleMapController?>(null);

  RxBool active = false.obs;
  RxBool isDriverActive = false.obs;
  RxBool locationInitialized = false.obs;
  RxBool openedAddressSearch = false.obs;
  RxBool openedSelectCar = false.obs;
  RxBool hasLoadedMarker = false.obs;
  RxBool dropOffSelected = false.obs;
  RxBool pickupSelected = false.obs;
  Rx<Position?> currentUserPosition = Rx<Position?>(null);
  Rx<Position?> driverCurrentPosition = Rx<Position?>(null);

  final _box = GetStorage();

  // favorite destinations
  Rx<FavouriteDestination?> home = Rx<FavouriteDestination?>(null);
  Rx<FavouriteDestination?> school = Rx<FavouriteDestination?>(null);
  Rx<FavouriteDestination?> work = Rx<FavouriteDestination?>(null);

  // bottom sheet variables
  RxDouble bottomSheetHeight = 220.00.obs;
  RxDouble bottomSheetDragOffset = 0.00.obs;

  Rx<LatLng> pickLocation = const LatLng(37.42839, -122.03845430).obs;
  Rx<LatLng> dropoffLocation = const LatLng(37.42839, -122.03845430).obs;
  Rx<loc.Location> location = loc.Location().obs;

  // search screen variables
  RxString address = ''.obs;
  final TextEditingController dropOffFieldEditingController =
      TextEditingController();
  final TextEditingController pickUpFieldEditingController =
      TextEditingController();

  var geolocation = Geolocator();

  Rx<CameraPosition> cameraPositionDefault = const CameraPosition(
    target: LatLng(37.42839, -122.03845430),
    zoom: 12.4746,
  ).obs;

  // markers and polyline variables
  final pLineCoordinatedList = <LatLng>[].obs;
  final listCordinates = <LatLng>[].obs;
  final markers = <Marker>{}.obs;
  final circles = <Circle>{}.obs;
  final polylineSet = <Polyline>{}.obs;

  RxDouble waitingResponseFromDriverContainerHeight = 0.00.obs;
  RxDouble assignedDriverContainerHeight = 0.00.obs;
  RxBool activeNearbyDriverKeyLoaded = false.obs;

  // trip details
  Rx<DirectionDetailsInfo?> tripInfo = Rx<DirectionDetailsInfo?>(null);
  RxBool onTransit = false.obs;
  RxString formattedETA = ''.obs;
  RxDouble amount = 0.0.obs;
  Rx<CarType?> vehicleType = Rx<CarType?>(null);
  // todo: remember to add this to the server to use in calculating the estimated distance of the trip
  RxDouble estimatedTripDistance = 0.00.obs;
  RxInt estimatedArrivalTime = 1.obs;
  // todo: remember to add this to the data sent to the server so you can use this to check the actual time of arrival and add extra funding
  Rx<DateTime> arrivalTime = DateTime.now().obs;
  RxDouble estimatedTripCost = 0.00.obs;

  // global keys for the markers
  final GlobalKey currentUserMarkerKey = GlobalKey();
  final GlobalKey pickupKey = GlobalKey();
  final GlobalKey dropoffKey = GlobalKey();

  // todo remember to use substring to concatenate the location length
  Rx<Directions?> userPickupLocation = Directions().obs;
  Rx<Directions?> userDropOffLocation = Directions().obs;
  RxInt countTotalTrips = 0.obs;
  RxList<String> historyTripsKeyList = RxList<String>([]);
  RxList<TripsHistoryModel> allTripsHistoryInformationList =
      RxList<TripsHistoryModel>([]);
  RxList<CarType> carTypes = RxList<CarType>([]);

  // ? Driver variables
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  DriverData driverData = DriverData();
  RxString statusText = "Offline".obs;
  RxDouble totalTimeDriven = 0.0.obs;
  Rx<TripsHistoryModel?> lastTripHistoryInformationModel =
      Rx<TripsHistoryModel?>(null);
  Rx<DirectionDetailsInfo?> lastTripDirectionDetailsInformation =
      Rx<DirectionDetailsInfo?>(null);
  Rx<StreamSubscription<Position>?> streamSubscriptionPosition =
      Rx<StreamSubscription<Position>?>(null);
  Rx<StreamSubscription<Position>?> streamSubscriptionDriverPosition =
      Rx<StreamSubscription<Position>?>(null);

  Future<void> onBuildCompleted() async {
    if (AuthController.find.getNewMarkers.value ||
        _box.read('userIcon') == null) {
      final Uint8List markerIcon =
          await convertWidgetToMarker(currentUserMarkerKey, 2.3);
      _box.write('userIcon', markerIcon);
      userIcon.value = BitmapDescriptor.fromBytes(markerIcon);
    } else {
      List<int> iconList = List<int>.from(_box.read('userIcon'));
      Uint8List int8data = Uint8List.fromList(iconList);
      BitmapDescriptor icon = BitmapDescriptor.fromBytes(int8data);
      userIcon.value = icon;
    }

    if (AuthController.find.getNewMarkers.value ||
        _box.read('pickupIcon') == null) {
      final Uint8List pickupMarker =
          await convertWidgetToMarker(pickupKey, 3.0);
      _box.write('pickupIcon', pickupMarker);
      pickupIcon.value = BitmapDescriptor.fromBytes(pickupMarker);
    } else {
      List<int> iconList = List<int>.from(_box.read('pickupIcon'));
      Uint8List int8List = Uint8List.fromList(iconList);
      BitmapDescriptor icon = BitmapDescriptor.fromBytes(int8List);
      pickupIcon.value = icon;
    }

    dropoffIcon.value = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed); // BitmapDescriptor.fromBytes(dropoffMarker);
    // loadGoogleMap();

    hasLoadedMarker.value = true;
  }

  Future<Uint8List> convertWidgetToMarker(
      GlobalKey markerKey, double ratio) async {
    RenderRepaintBoundary boundary =
        markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: ratio);
    ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    /*
    Function to calculate the direction bounds to 
    be used to animate the camera to show this distance in full.

    ? REQUIRED: List of LatLng points or cordinates for both pickup and destination.
    */
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latlng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latlng.latitude;
        y0 = y1 = latlng.longitude;
      } else {
        if (latlng.latitude > x1) x1 = latlng.latitude;
        if (latlng.latitude < x0) x0 = latlng.latitude;
        if (latlng.longitude > y1) y1 = latlng.longitude;
        if (latlng.longitude < y0) y0 = latlng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void updatePickupLocationAddress(Directions userPickupAddress) {
    userPickupLocation.value = userPickupAddress;
    pickUpFieldEditingController.text = userPickupLocation.value!.locationName!;
    update();
  }

  void updateDropoffLocationAddress(Directions dropOffPickupAddress) {
    userDropOffLocation.value = dropOffPickupAddress;
    dropOffFieldEditingController.text =
        userDropOffLocation.value!.locationName!;
    update();
  }

  void updateTotalTrips(int totalTripsCount) {
    countTotalTrips.value = totalTripsCount;
  }

  void updateTotalTripsList(List<String> rideRequestKeyList) {
    historyTripsKeyList.value = rideRequestKeyList;
  }

  void updateTotalHistoryInformation(
      TripsHistoryModel eachTripHistoryInformation) {
    allTripsHistoryInformationList.add(eachTripHistoryInformation);
  }

  void updateLastHistoryInformation(
      TripsHistoryModel lastTripHistoryInformation,
      DirectionDetailsInfo lastTripDirectionDetailsInfo) {
    lastTripHistoryInformationModel.value = lastTripHistoryInformation;
    lastTripDirectionDetailsInformation.value = lastTripDirectionDetailsInfo;
  }

  void updateDriverRating(UserRating rating, UserModel user) async {
    await UserRepository.instance.addNewRating(user.uid!, rating);
  }

  void updatePolylineCoordinates(List<LatLng> coordinates) {
    pLineCoordinatedList.clear();
    pLineCoordinatedList.addAll(coordinates);
  }

  Future<void> getPolyPoints(Directions pickup, Directions destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    final final_pickup =
        PointLatLng(pickup.locationLatitude!, pickup.locationLongitude!);
    final final_destination = PointLatLng(
        destination.locationLatitude!, destination.locationLongitude!);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_API_KEY,
      final_pickup,
      final_destination,
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      listCordinates.clear();
      for (var point in result.points) {
        listCordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      LatLngBounds bounds = boundsFromLatLngList(listCordinates);
      setTripMarkers();
      Future.delayed(
          const Duration(milliseconds: 200),
          () => newGoogleMapController.value!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100)));
      updatePolylineCoordinates(listCordinates);
      update();
    }
  }

  void setPickupMarker() async {
    // if (!AuthController.find.userModel.value!.isDriver) {
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: pickLocation.value,
        icon: userIcon.value,
        draggable: true,
        anchor: const Offset(0.5, 0.5),
        onDragEnd: (value) async {
          pickupSelected.value = true;
          pickLocation.value = LatLng(value.latitude, value.longitude);

          await getAddressFromLatLng();

          cameraPositionDefault.value =
              CameraPosition(target: pickLocation.value, zoom: 13.765);
          newGoogleMapController.value!.animateCamera(
              CameraUpdate.newCameraPosition(cameraPositionDefault.value));
        },
      ),
    );
    // }
  }

  void setTripMarkers() async {
    markers.clear();
    polylineSet.clear();

    // if (!AuthController.find.userModel.value!.isDriver) {
    markers.add(Marker(
      markerId: const MarkerId('pickup'),
      position: LatLng(userPickupLocation.value!.locationLatitude!,
          userPickupLocation.value!.locationLongitude!),
      icon: pickupIcon.value,
      draggable: true,
      anchor: const Offset(0.45, 0.68),
      onDragEnd: (value) async {
        if (!onTransit.value) {
          pickLocation.value = LatLng(value.latitude, value.longitude);
          await getAddressFromLatLng();
          await calculateDistance();
          await calculateETA();
          await getPolyPoints(
              userPickupLocation.value!, userDropOffLocation.value!);

          update();
        }
      },
    ));

    markers.add(Marker(
      markerId: const MarkerId('dropoff'),
      position: LatLng(userDropOffLocation.value!.locationLatitude!,
          userDropOffLocation.value!.locationLongitude!),
      icon: dropoffIcon.value,
      draggable: true,
      onDragEnd: (value) async {
        if (!onTransit.value) {
          dropoffLocation.value = LatLng(value.latitude, value.longitude);
          await getDropoffAddressFromLatLng();
          await calculateDistance();
          await calculateETA();
          await getPolyPoints(
              userPickupLocation.value!, userDropOffLocation.value!);
          update();
        }
      },
    ));
    // }
  }

  Future<double> calculateDistance() async {
    LatLng origin = LatLng(
      userPickupLocation.value!.locationLatitude!,
      userPickupLocation.value!.locationLongitude!,
    );
    LatLng destination = LatLng(
      userDropOffLocation.value!.locationLatitude!,
      userDropOffLocation.value!.locationLongitude!,
    );

    tripInfo.value =
        await AssistantMethods.getOriginToDestinationDirectionDetails(
            origin, destination);

    // estimated time for the trip
    formattedETA.value = tripInfo.value!.duration_text!;

    double km = tripInfo.value!.distance_value! * 1.00 / 1000;
    estimatedTripDistance.value = km;
    return km;
  }

  Future<void> calculateETA() async {
    // get the estimated time for arrival to be calculated against the final time they arrived
    int etaInMinutes = (tripInfo.value!.duration_value! * 60).round();
    estimatedArrivalTime.value = etaInMinutes;
    DateTime eta = DateTime.now().add(Duration(minutes: etaInMinutes));
    arrivalTime.value = eta;
  }

  Future<double> endRide() async {
    // get the set destination for the trip and then the current destination for the trip
    LatLng origin = LatLng(
      userPickupLocation.value!.locationLatitude!,
      userPickupLocation.value!.locationLongitude!,
    );
    LatLng finalStop = await getFinalStopCoordinates();

    tripInfo.value =
        await AssistantMethods.getOriginToDestinationDirectionDetails(
            origin, finalStop);

    estimatedTripCost.value =
        AssistantMethods.calculateFareAmountFromSourceToDestination(
                tripInfo.value!, vehicleType.value!)
            .roundToDouble();
    formattedETA.value = tripInfo.value!.duration_text!;

    return estimatedTripCost.value;
  }

  Future<LatLng> getFinalStopCoordinates() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentUserPosition.value = cPosition;

    LatLng latLngPosition = LatLng(currentUserPosition.value!.latitude,
        currentUserPosition.value!.longitude);
    pickLocation.value = latLngPosition;
    return latLngPosition;
  }

  void selectPickupCar(double amount, CarType vehicletype) {
    estimatedTripCost.value = amount;
    vehicleType.value = vehicletype;
    update();
  }

  void updateAmount(double newAmount) {
    amount.value = newAmount;
    update();
  }

  void goToMyLocation() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentUserPosition.value = cPosition;

    LatLng latLngPosition = LatLng(currentUserPosition.value!.latitude,
        currentUserPosition.value!.longitude);
    pickLocation.value = latLngPosition;
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 17.765);

    cameraPositionDefault.value = cameraPosition;
    newGoogleMapController.value!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentUserPosition.value = cPosition;

    LatLng latLngPosition = LatLng(currentUserPosition.value!.latitude,
        currentUserPosition.value!.longitude);
    pickLocation.value = latLngPosition;

    if (!dropOffSelected.value) {
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 17.765);

      cameraPositionDefault.value = cameraPosition;
      newGoogleMapController.value!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      getAddressFromLatLng();
      setPickupMarker();
    } else {
      LatLngBounds bounds = boundsFromLatLngList(listCordinates);
      setTripMarkers();
      Future.delayed(
          const Duration(milliseconds: 200),
          () => newGoogleMapController.value!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100)));
      updatePolylineCoordinates(listCordinates);
    }
    // AssistantMethods.readTripsKeyForOnlineUser(context);
  }

  Future<void> getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation.value.latitude,
        longitude: pickLocation.value.longitude,
        googleMapApiKey: GOOGLE_API_KEY,
      );

      if (!locationInitialized.value) {
        AuthController.find.userCurrentState.value = await LocationRepository
            .instance
            .getCurrentUserLocationState(data.state);
      }

      Directions userPickupAddress = Directions();
      userPickupAddress.locationName = data.address;
      userPickupAddress.locationLatitude = pickLocation.value.latitude;
      userPickupAddress.locationLongitude = pickLocation.value.longitude;
      // address.value = data.address;

      updatePickupLocationAddress(userPickupAddress);
    } catch (e) {
      showErrorMessage(
          'Pickup Geocoding Error', e.toString(), FontAwesomeIcons.locationPin);
    }
  }

  Future<void> getDropoffAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation.value.latitude,
        longitude: pickLocation.value.longitude,
        googleMapApiKey: GOOGLE_API_KEY,
      );

      Directions userDropoffAddress = Directions();
      userDropoffAddress.locationName = data.address;
      userDropoffAddress.locationLatitude = dropoffLocation.value.latitude;
      userDropoffAddress.locationLongitude = dropoffLocation.value.longitude;

      updateDropoffLocationAddress(userDropoffAddress);
    } catch (e) {
      showErrorMessage('Dropoff Geocoding Error', e.toString(),
          FontAwesomeIcons.locationPin);
    }
  }

  Future<void> getDropoffAddressFromText(String address) async {
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
      showErrorMessage('Dropoff Text Geocoding Error', e.toString(),
          FontAwesomeIcons.locationPin);
    }
  }
}

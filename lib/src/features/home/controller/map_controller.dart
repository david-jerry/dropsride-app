// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/assistants/Geofire_assistant.dart';
import 'package:dropsride/src/assistants/assistant_methods.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/home/model/active_nearby_available_drivers.dart';
import 'package:dropsride/src/features/home/model/car_type_pricing_model.dart';
import 'package:dropsride/src/features/home/model/direction_details_info_model.dart';
import 'package:dropsride/src/features/home/model/directions_model.dart';
import 'package:dropsride/src/features/home/model/ride_request_information.dart';
import 'package:dropsride/src/features/home/view/driver_map_view.dart';
import 'package:dropsride/src/features/home/view/index.dart';
import 'package:dropsride/src/features/profile/controller/repository/user_repository.dart';
import 'package:dropsride/src/features/profile/model/favorite_destinations_model.dart';
import 'package:dropsride/src/features/profile/model/user_model.dart';
import 'package:dropsride/src/features/trips/controller/repository/location_repository.dart';
import 'package:dropsride/src/features/trips/model/car_types.dart';
import 'package:dropsride/src/features/trips/model/trip_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final String GOOGLE_API_KEY = dotenv.env['MAP_API_KEY']!;
const cam = CameraPosition(target: LatLng(37.42839, -122.03845430), zoom: 14);

class MapController extends GetxController {
  static MapController get find => Get.find<MapController>();

  AuthController auth = Get.find<AuthController>();
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  RxString currencySymbol = ''.obs;
  RxString cms =
      'key=AAAA1hAGvkM:APA91bECoP-TM71GPCScLjrUbjLNzU6AJX4aQ7UCItBqULcObIRKI8p_nYxh6UKybnKflsMhRuCdR13BhPYaw2ajo3Hr4DNWOMpI7pNEepTSdrGvYiW1p7xrc3wHBgVSivk9Gjq33ixM'
          .obs;

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
  RxBool showSelectedDriver = false.obs;
  RxBool showTripInfoAlertToDriver = false.obs;
  RxBool showAssignedDriver = false.obs;
  RxBool markerDragged = false.obs;
  RxBool searchingDropoff = true.obs;
  RxBool locationChanged = false.obs;
  RxBool isDriverActive = false.obs;
  RxBool locationInitialized = false.obs;
  RxBool openedAddressSearch = false.obs;
  RxBool openedSelectCar = false.obs;
  RxBool confirmTrip = false.obs;
  RxBool hasLoadedMarker = false.obs;
  RxBool dropOffSelected = false.obs;
  RxBool pickupSelected = false.obs;
  // ? After confirming a ride and sending the request to the driver we listen
  // ? for changes on the ride request depending on what the driver selects to update the rider state
  RxBool bookingConfirmed = false.obs;
  RxBool showDriversMarker = true.obs;
  RxDouble progressbarValue = 0.0.obs;
  RxBool rideAccepted = false.obs;
  RxBool rideCancelled = false.obs;
  RxBool driverArriving = false.obs;
  RxBool driverArrived = false.obs;
  RxBool tripStarted = false.obs;
  RxBool onTheTrip = false.obs;
  RxBool tripHasEnded = false.obs;
  RxBool ridePaused = false.obs;
  // ? driver ride request enable pop up
  RxBool newRideRequest = false.obs;
  // ? this is to control the live locations on the map
  Rx<Position?> currentUserPosition = Rx<Position?>(null);
  Rx<Position?> driverCurrentPosition = Rx<Position?>(null);

  final _box = GetStorage();

  // favorite destinations
  Rx<FavouriteDestination?> home = FavouriteDestination().obs;
  Rx<FavouriteDestination?> school = FavouriteDestination().obs;
  Rx<FavouriteDestination?> work = FavouriteDestination().obs;

  // bottom sheet variables
  RxDouble bottomSheetHeight = 220.00.obs;
  RxDouble bottomSheetDragOffset = 0.00.obs;
  RxDouble showSelectedDriverBottomSheetHeight = 0.0.obs;

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
  AnimationController? animationController;
  final CircleId circleId = const CircleId('picker_circle');
  Animation<double>? animation;
  RxDouble circleRadius = 100.0.obs;
  RxDouble maxCircleRadius = 200.0.obs;

  final pLineCoordinatedList = <LatLng>[].obs;
  Timer? timer;
  final listCordinates = <LatLng>[].obs;
  final markers = <Marker>{}.obs;
  final circles = <Circle>{}.obs;
  final polylineSet = <Polyline>{}.obs;

  RxDouble waitingResponseFromDriverContainerHeight = 0.00.obs;
  RxDouble assignedDriverContainerHeight = 0.00.obs;
  RxBool activeNearbyDriverKeyLoaded = false.obs;

  // trip details
  Rx<DirectionDetailsInfo?> tripInfo = DirectionDetailsInfo().obs;
  RxBool onTransit = false.obs;
  RxString formattedETA = ''.obs;
  RxDouble amount = 0.0.obs;
  Rx<CarType?> vehicleType = CarType().obs;
  // todo: remember to add this to the server to use in calculating the estimated distance of the trip
  RxDouble estimatedTripDistance = 0.00.obs;
  RxInt estimatedArrivalTime = 1.obs;
  // todo: remember to add this to the data sent to the server so you can use this to check the actual time of arrival and add extra funding
  Rx<DateTime> arrivalTime = DateTime.now().obs;
  RxDouble estimatedTripCost = 0.00.obs;
  RxString tripRequestDocRef = ''.obs;
  Rx<RideRequestInformation> tripInformation = RideRequestInformation().obs;
  DatabaseReference? referenceRideRequest;
  DocumentReference<Map<String, dynamic>>? tripRequestDocumentRef;
  RxString driverArrivalTime = ''.obs;

  RxString carColor = ''.obs;
  RxString carName = ''.obs;
  RxString driverPhoto = ''.obs;
  RxDouble driverRating = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString plateNumber = ''.obs;

  // global keys for the markers
  final GlobalKey currentUserMarkerKey = GlobalKey();
  final GlobalKey driverMarkerMaoKey = GlobalKey();
  final GlobalKey pickupKey = GlobalKey();
  final GlobalKey dropoffKey = GlobalKey();

  // todo remember to use substring to concatenate the location length
  Rx<Directions?> userPickupLocation = Directions().obs;
  Rx<Directions?> userDropOffLocation = Directions().obs;
  RxInt countTotalTrips = 0.obs;
  RxList<String> historyTripsKeyList = <String>[].obs;
  RxList<TripsHistoryModel> allTripsHistoryInformationList =
      <TripsHistoryModel>[].obs;
  Rx<ActiveNearbyAvailableDrivers> activeNearbyDriver =
      ActiveNearbyAvailableDrivers().obs;
  RxList<UserModel> activeOnlineNearbyDriverList = <UserModel>[].obs;
  RxList<CarType> carTypes = <CarType>[].obs;
  RxList<CarPricing> carPricing = <CarPricing>[].obs;

  // ? Driver variables
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  Rx<DriverModel> driverData = DriverModel().obs;
  RxDouble totalTimeDriven = 0.0.obs;
  Rx<TripsHistoryModel?> lastTripHistoryInformationModel =
      TripsHistoryModel().obs;
  Rx<DirectionDetailsInfo?> lastTripDirectionDetailsInformation =
      DirectionDetailsInfo().obs;
  StreamSubscription<DatabaseEvent>? tripRideRequestSnapshotInfo;

  // ? Driver direction
  StreamSubscription<Position>? streamSubscriptionPosition;
  StreamSubscription<Position>? streamSubscriptionDriverPosition;

  @override
  void onInit() {
    super.onInit();
    getCurrency('NGN');
  }

  void cancelRideRequesting() {
    active.value = false;
    searchingDropoff.value = true;
    locationChanged.value = false;
    isDriverActive.value = false;
    locationInitialized.value = false;
    openedAddressSearch.value = false;
    bookingConfirmed.value = true;
    progressbarValue.value = 0;
    rideAccepted.value = false;
    rideCancelled.value = false;
    driverArriving.value = false;
    driverArrived.value = false;
    onTheTrip.value = false;
    tripHasEnded.value = false;
    ridePaused.value = false;
    openedSelectCar.value = false;
    confirmTrip.value = false;
    hasLoadedMarker.value = false;
    dropOffSelected.value = false;
    pickupSelected.value = false;
    showDriversMarker.value = true;
    showAssignedDriver.value = false;
    showSelectedDriver.value = false;
    userDropOffLocation.value = Directions();
    userPickupLocation.value = Directions();
    tripInfo.value = DirectionDetailsInfo();
    rideAccepted.value = false;
    pLineCoordinatedList.value = <LatLng>[];
    listCordinates.value = <LatLng>[];
    markers.clear();
    circles.clear();
    dropOffFieldEditingController.text = '';

    if (_box.read('tripRequestDocRef') != null) {
      _box.remove('tripRequestDocRef');
    }

    // locateUserPosition();
    tripRideRequestSnapshotInfo!.cancel();
    Get.offAll(const HomeScreen());
  }

  // ? get currency symbol
  String getCurrency(String? countryCode) {
    var format = NumberFormat.simpleCurrency(
        locale: Platform.localeName, name: countryCode?.toUpperCase() ?? 'NGN');
    return format.currencySymbol;
  }

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

    // final Uint8List
    final driverMarker = await convertWidgetToMarker(driverMarkerMaoKey, 3.5);

    if (driverMarker != null) {
      _box.write('driverIcon', driverMarker);
      activeNearbyIcon.value = BitmapDescriptor.fromBytes(driverMarker);
      // activeNearbyIcon.value = await BitmapDescriptor.fromAssetImage(
      //     ImageConfiguration.empty, Assets.assetsImagesDriverIconCarTop);

      hasLoadedMarker.value = true;
    }
  }

  Future<dynamic> convertWidgetToMarker(
      GlobalKey markerKey, double ratio) async {
    if (markerKey.currentContext != null) {
      RenderRepaintBoundary boundary =
          markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: ratio);
      ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data!.buffer.asUint8List();
    }
    return null;
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

  Future<void> getCordinateLists(List<PointLatLng> points) async {
    for (var point in points) {
      listCordinates.add(
        LatLng(point.latitude, point.longitude),
      );
    }
  }

  Future<void> getPolyPoints(Directions pickup, Directions destination) async {
    print("Starting to get the polypoints");
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

    print(result.points.length);

    if (result.points.isNotEmpty) {
      listCordinates.clear();
      print("Cleared cordinate polyline points");
      await getCordinateLists(result.points);
      print(listCordinates.length);

      LatLngBounds bounds = boundsFromLatLngList(listCordinates);
      setTripMarkers();
      Future.delayed(
          const Duration(milliseconds: 200),
          () => newGoogleMapController.value!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100)));
      updatePolylineCoordinates(listCordinates);
      if (!markerDragged.value) {
        await calculateDistance();
      }
      update();
    }
  }

  Future<void> getDriverArrivalPolyPoints(
      PointLatLng pickup, Directions destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    final final_pickup = pickup;
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
      await getCordinateLists(result.points);
      LatLngBounds bounds = boundsFromLatLngList(listCordinates);

      Future.delayed(
          const Duration(milliseconds: 200),
          () => newGoogleMapController.value!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100)));
      updatePolylineCoordinates(listCordinates);
      update();
    }
  }

  void setPickupMarker() async {
    circles.clear();
    markers.clear();
    // if (!AuthController.find.userModel.value!.isDriver) {

    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: pickLocation.value,
        icon: auth.userModel.value!.isDriver
            ? activeNearbyIcon.value
            : userIcon.value,
        draggable: true,
        anchor: const Offset(0.5, 0.5),
        onDragEnd: (value) async {
          timer?.cancel();
          pickupSelected.value = true;
          pickLocation.value = LatLng(value.latitude, value.longitude);

          await getAddressFromLatLng();
          startCircleAnimation();

          circleRadius.value = 280;

          circles.clear();

          circles.add(
            Circle(
              circleId: circleId,
              center: LatLng(value.latitude, value.longitude),
              radius: circleRadius.value,
              fillColor: AppColors.primaryColor.withOpacity(0.4),
              strokeColor: AppColors.primaryColor,
              strokeWidth: 2,
            ),
          );

          cameraPositionDefault.value =
              CameraPosition(target: pickLocation.value, zoom: 13.765);
          newGoogleMapController.value!.animateCamera(
              CameraUpdate.newCameraPosition(cameraPositionDefault.value));
        },
      ),
    );

    if (!auth.userModel.value!.isDriver) {
      circles.add(
        Circle(
          circleId: circleId,
          center: pickLocation.value,
          radius: circleRadius.value,
          fillColor: AppColors.primaryColor.withOpacity(0.4),
          strokeColor: AppColors.primaryColor,
          strokeWidth: 2,
        ),
      );
      startCircleAnimation();
    }
  }

  void setTripMarkers() async {
    markers.clear();
    polylineSet.clear();
    circles.clear();

    // if (!AuthController.find.userModel.value!.isDriver) {
    markers.add(Marker(
      markerId: const MarkerId('pickup'),
      position: LatLng(userPickupLocation.value!.locationLatitude!,
          userPickupLocation.value!.locationLongitude!),
      icon: pickupIcon.value,
      draggable: true,
      anchor: const Offset(0.45, 0.68),
      onDragEnd: (value) async {
        markerDragged.value = true;
        if (!onTransit.value || confirmTrip.value) {
          pickLocation.value = LatLng(value.latitude, value.longitude);
          await getAddressFromLatLng();
          await calculateDistance();
          await calculateETA();
          await getPolyPoints(
              userPickupLocation.value!, userDropOffLocation.value!);
          markerDragged.value = false;
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
        markerDragged.value = true;
        if (!onTransit.value || confirmTrip.value) {
          dropoffLocation.value = LatLng(value.latitude, value.longitude);
          await getDropoffAddressFromLatLng();
          await calculateDistance();
          await calculateETA();
          await getPolyPoints(
              userPickupLocation.value!, userDropOffLocation.value!);
          markerDragged.value = false;
          update();
        }
      },
    ));
    // }
  }

  void setDriverArrivalMarkers(LatLng driverPoint) async {
    markers.clear();
    polylineSet.clear();
    circles.clear();

    // if (!AuthController.find.userModel.value!.isDriver) {
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: driverPoint,
        icon: pickupIcon.value,
        draggable: false,
        anchor: const Offset(0.45, 0.68),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: driverPoint,
        icon: activeNearbyIcon.value,
        draggable: false,
        anchor: const Offset(0.5, 0.5),
      ),
    );
    // }
  }

  Future<void> calculateDriverArriverTime(LatLng driverLatLng) async {
    circles.clear();
    markers.clear();
    polylineSet.clear();

    LatLng origin = LatLng(
      userPickupLocation.value!.locationLatitude!,
      userPickupLocation.value!.locationLongitude!,
    );

    PointLatLng driverPointLatLng =
        PointLatLng(driverLatLng.latitude, driverLatLng.longitude);

    final arrivalInfo =
        await AssistantMethods.getOriginToDestinationDirectionDetails(
            origin, driverLatLng);

    driverArrivalTime.value = arrivalInfo!.duration_text!;

    setDriverArrivalMarkers(driverLatLng);

    await getDriverArrivalPolyPoints(
        driverPointLatLng, userPickupLocation.value!);
  }

  Future<double> calculateDistance() async {
    carPricing.clear();
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
    getCarList();
    calculateETA();
    return km;
  }

  Future<void> getCarList() async {
    for (dynamic carType in carTypes) {
      if (carType.name != 'Unassigned') {
        double amount =
            AssistantMethods.calculateFareAmountFromSourceToDestination(
                    tripInfo.value!, carType)
                .toDouble();
        CarPricing pricing = CarPricing(
          carType: carType,
          km: estimatedTripDistance.value.round().toString(),
          amount: amount,
        );
        carPricing.add(pricing);
      }
    }
  }

  Future<void> calculateETA() async {
    // get the estimated time for arrival to be calculated against the final time they arrived
    double mins = tripInfo.value!.duration_value! / 60;
    int etaInMinutes = mins.round();
    estimatedArrivalTime.value = mins.round();
    // etaInMinutes;
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

  Future<void> acceptRide(String rideRequestID) async {
    final driverData = TripsHistoryModel(
      status: TripStatus.accepted,
      driverId: auth.userModel.value!.uid,
      driverName: auth.userModel.value!.displayName,
      carColor: auth.driverVehicleModel.value!.carColor,
      driverPhone: auth.userModel.value!.phoneNumber!.completeNumber,
      driverPhoto: auth.userModel.value!.photoUrl,
      driverRating: 1.0 * auth.userRating.value,
      plateNumber: auth.driverVehicleModel.value!.carPlateNumber,
      longitude: map.pickLocation.value.longitude,
      latitude: map.pickLocation.value.latitude,
      carName: auth.driverVehicleModel.value!.carModel,
    );
    _firebaseDatabase
        .ref()
        .child("trips")
        .child(rideRequestID)
        .set(driverData.toDriverMap());
    AssistantMethods.pauseLiveLocationUpdates();

    rideAccepted.value = true;
    showDriversMarker.value = false;
    driverArriving.value = true;

    Get.offAll(const DriverAcceptedRideScreen());
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

  void selectPickupCar(double amount, CarType? vehicletype) {
    dropOffSelected.value = true;
    openedAddressSearch.value = false;
    openedSelectCar.value = true;
    locationChanged.value = false;
    confirmTrip.value = true;
    bookingConfirmed.value = true;
    rideAccepted.value = false;
    bottomSheetHeight.value = 376;
    estimatedTripCost.value =
        AssistantMethods.calculateFareAmountFromSourceToDestination(
                tripInfo.value!, vehicletype!)
            .toDouble();
    vehicleType.value = vehicletype;
    update();
  }

  void startCircleAnimation() {
    timer = Timer.periodic(const Duration(milliseconds: 5500), (_) {
      if (circleRadius.value == 100.0) {
        circleRadius.value = 300.0;
      } else {
        circleRadius.value = 100.0;
      }
    });
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
    update();
  }

  void locateUserPosition() async {
    markers.clear();
    circles.clear();
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentUserPosition.value = cPosition;

    LatLng latLngPosition = LatLng(currentUserPosition.value!.latitude,
        currentUserPosition.value!.longitude);
    pickLocation.value = latLngPosition;

    if (!dropOffSelected.value) {
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 15.765);

      cameraPositionDefault.value = cameraPosition;
      newGoogleMapController.value!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      getAddressFromLatLng();
      setPickupMarker();
    } else {
      if (listCordinates.isNotEmpty) {
        LatLngBounds bounds = boundsFromLatLngList(listCordinates);
        setTripMarkers();
        Future.delayed(
            const Duration(milliseconds: 200),
            () => newGoogleMapController.value!
                .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100)));
        updatePolylineCoordinates(listCordinates);
      }
    }

    // if (!auth.userModel.value!.isDriver) {
    //   initializeGeoFireListener();
    // }

    initializeGeoFireListener();
    LocationRepository.instance.getActiveTrip();
    // AssistantMethods.readTripsKeyForOnlineUser(context);
  }

  Future<void> initializeGeoFireListener() async {
    await Geofire.initialize('activeDrivers');

    await Geofire.queryAtLocation(
      pickLocation.value.latitude,
      pickLocation.value.longitude,
      10,
    )!.listen(
      (map) {
        if (map != null) {
          var callback = map['callBack'];

          switch (callback) {
            // whenever any driver becomes active or online
            case Geofire.onKeyEntered:
              activeNearbyDriver.value.locationLatitude = map['latitude'];
              activeNearbyDriver.value.locationLongitude = map['longitude'];
              activeNearbyDriver.value.driverId = map['key'];
              GeoFireAssistant.activeNearbyAvailableDriversList
                  .add(activeNearbyDriver.value);
              if (activeNearbyDriverKeyLoaded.value) {
                displayActiveDriversOnRiderMap();
              }
              break;

            // whenever any driver becomes non-active or offline
            case Geofire.onKeyExited:
              GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
              displayActiveDriversOnRiderMap();
              break;

            // whenever a driver moves update drivers location
            case Geofire.onKeyMoved:
              activeNearbyDriver.value.locationLatitude = map['latitude'];
              activeNearbyDriver.value.locationLongitude = map['longitude'];
              activeNearbyDriver.value.driverId = map['key'];
              GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                  activeNearbyDriver.value);
              displayActiveDriversOnRiderMap();
              break;

            // display drivers who are online and active on the riders map
            case Geofire.onGeoQueryReady:
              activeNearbyDriverKeyLoaded.value = true;
              displayActiveDriversOnRiderMap();
              break;
          }
        }
      },
    );
  }

  Future<void> displayActiveDriversOnRiderMap() async {
    if (showDriversMarker.value) {
      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        if (eachDriver.driverId != auth.userModel.value!.uid) {
          markers.add(Marker(
            markerId: MarkerId(eachDriver.driverId!),
            position: eachDriverActivePosition,
            icon: activeNearbyIcon.value,
            draggable: false,
            rotation: 360,
          ));
        }
      }
    }
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

  Future<void> getPickupAddressFromText(String address) async {
    try {
      GeoData data = await Geocoder2.getDataFromAddress(
        address: address,
        googleMapApiKey: GOOGLE_API_KEY,
      );

      Directions userPickupAddress = Directions();
      userPickupAddress.locationName = data.address;
      userPickupAddress.locationLatitude = data.latitude;
      userPickupAddress.locationLongitude = data.longitude;

      updatePickupLocationAddress(userPickupAddress);
    } catch (e) {
      showErrorMessage('Dropoff Text Geocoding Error', e.toString(),
          FontAwesomeIcons.locationPin);
    }
  }
}
